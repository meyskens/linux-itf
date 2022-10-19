# Getting "a kube"

Before we get started we need a Kubernetes cluster to use! Several cloud providers offer Kubernetes as a service, but we're going to use [kind](https://kind.sigs.k8s.io/) to create a local cluster to play with first. If you're interested in deploying a multi server solution we'll look into the official Kubernetes distribution [kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/) later.

## The k8s cluster

A k8s cluster is a group of machines, each machine is called a node. Nodes can have different roles in k8s:

- "Controller" or "master" nodes that run the Kubernetes API and the control plane
  - You can run multiple controllers (in uneven numbers) to have a highly available cluster
- One or more "worker" node that run the actual workloads (= pods with containers).

![k8s cluster](https://opensource.com/sites/default/files/uploads/kubernetes-architecture-diagram.png)

*(Nived Velayudhan, CC BY-SA 4.0)*

## The Laptop Essentials: `kubectl`

Before we can start we need to install `kubectl` which is the command line tool to interact with Kubernetes. You can find the installation instructions [on the official website](https://kubernetes.io/docs/tasks/tools/install-kubectl/).

You can compare it to the `systemctl` to `systemd` but for Kubernetes. Some people also see it as a kind of SSH alternative as many developers will use it on their local machine to interact with a remote cluster.

In our class we will use `kubectl` to interact with our local cluster on our Linux VM (as the Linux bash shell is just way beter![^bashbetter]).

```bash
# Install kubectl
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
```

When you do `kubectl version` you should see the version of your client.

:::tip
You can have a [cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) on the official website.
:::

### The `kubeconfig`

The `kubeconfig` is a file that contains all the information to connect to a Kubernetes cluster. It is a YAML file that contains all the information to connect to one or multiple cluster. It is often shared between developers to get cluster access but should be considered as confidential as a password.

You can find it at `~/.kube/config` on macOS/Linux and `C:\Users\%USERNAME%\.kube\config` on Windows.

## kind - the developer's friend

[kind](https://kind.sigs.k8s.io/docs/user/quick-start/) is a tool to run local Kubernetes clusters using Docker containers. It is a great tool for developers as it is fast and lightweight compared to other solutions. It is an alternative to [minikube](https://minikube.sigs.k8s.io/docs/start/) which uses VMs under the hood so will be slower and more resource intensitive.

You can install it with the following command:

```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.16.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

If you need a cluster it is as easy as running `kind create cluster` and you will have a cluster (containing only one node) running in a few seconds. You can then interact with it with `kubectl` as you would with any other cluster, the credentials are automatically configured.

Check it out with `kubectl get nodes`:

```bash
$ kubectl get nodes
NAME                 STATUS   ROLES                  AGE   VERSION
kind-control-plane   Ready    control-plane,master   10s   v1.22.2
```

When you are done you can delete the cluster with `kind delete cluster`.

When we use kind in class it is a good idea to enable ingress support so that we can use HTTP/HTTPS routing. First, create a kind configuration file and then load it while creating the kind cluster:
```bash
$ cat kindconfig
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP

$ kind create cluster --config=kindconfig
Creating cluster "kind" ...
 ✓ Ensuring node image (kindest/node:v1.25.2) 🖼
 ✓ Preparing nodes 📦 📦 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
 ✓ Joining worker nodes 🚜
Set kubectl context to "kind-kind"
You can now use your cluster with:

kubectl cluster-info --context kind-kind

Thanks for using kind! 😊
```

Want to create a multi-node cluster? Then you can use the following kind configuration file, which sets up 1 controller node and 2 worker nodes:
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
- role: worker
```

### Ingress

kind doesn't come with an ingress controller out of the box. We will use [ingress-nginx](https://kubernetes.github.io/ingress-nginx/) which is the most popular ingress controller for Kubernetes.

```bash
# Now let's install our ingress controller component
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
kubectl get pod --all-namespaces # watch to see them all starting
```

### Storage

kind has a built in local storage provider, we will use that to make Presistent Volumes available in our cluster.

## kubeadm - the production ready official way

[kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/) is the community supported way to install Kubernetes. It is a great tool to install a production-ready Kubernetes cluster. It is a bit more complex to use than kind but it will get you started with a real cluster in no time.

To set it up you need:

- One "controller" node that has the Kubernetes API and the control plane
  - You can run multiple controllers (in uneven numbers) to have a highly available cluster
- One or more "worker" node that run the actual workloads

### Prepare the servers

Before we get started we need to prepare our Ubuntu servers to run Kubernetes and have containerd.

```bash
# load needed network kernel modules
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Install containerd (the container runtime)
sudo apt-get update && sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
```

### The controller

The controller is the server that runs the Kubernetes API and the control plane. It is the server that you will connect to when you use `kubectl`.

You can install it with the following command:

```bash
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl # prevent auto-updates
```

You can then initialize the cluster with the following command:

```bash
kubeadm init --pod-network-cidr=172.16.0.0/12
```

This command will set up the cluster and print a command to run on the worker nodes to join the cluster.

### The workers

To set up a worker node you need a set up token from the controller. You can get it with the following command:

```bash
kubeadm token create --print-join-command
```

This will output a command that you can run on the worker nodes to join the cluster.

But first you need to install the same packages as on the controller:

```bash
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl # prevent auto-updates
```

When you have the command from the controller you can run it on the worker nodes to join the cluster.
You can check the status of the cluster with `kubectl get nodes`.

## Batteries not included

Kubeadm uses a very minimal set of components to run Kubernetes, this is so it is not opinionated on tools that are not part of the Kubernetes community. You will need to install additional components to get a full featured cluster.

### Networking

This is an **essential\_** component of Kubernetes. Without a networking solution you will not be able to communicate between pods or let alone start them.

There are many networking solutions available, the most popular one is [Calico](https://www.projectcalico.org/). You can install it with the following command:

```bash
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

Calico is responsible for building an overlay network between the nodes in your cluster. It will also assign IP addresses to the pods and services in your cluster on this network. This network is only accessible from within the cluster.

### Optional: LoadBalancer Services

If you want to expose your services ports to the outside world using a "floating IP" you will need a LoadBalancer. This is a component that will expose your services to the outside world. Your cloud provider will often have it's own LoadBalancer, but if you are running on bare metal you will need to install one yourself like [MetalLB](https://metallb.org/).

When installing MetalLB you will need to configure it with a range of IP addresses that it can use, once in use it will start answering ARP requests for these IP addresses and forward the traffic to the correct service.

### Optional: Storage

Storage is yet another service that is typically provided by your cloud provider. Open source self-hosted solutions like [OpenEBS](https://openebs.io/) provide a way to run your own storage solution. It offers many options with different performance and redundancy ranges.

Unless you set up a production environment I recommend to try [Local PV Hostpath](https://openebs.io/docs/user-guides/localpv-hostpath) which will create a directory on the host and use that as a storage solution. **This is not a production ready solution** as it will assign it to only _one_ server, but it is easy to set up and will work for most use cases.

### Ingress

Just like before with kind, we need our own ingress controller. The most popular one is [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/).

However when doing this you should consider several load balancing options... Everything you need is described in the [Bare-metal considerations guide](https://kubernetes.github.io/ingress-nginx/deploy/baremetal/).

### The local multi VM cluster? Vagrant of course!

Want to get going with a multi server Kubernetes cluster on your laptop? Remember Vagrant from the first class of the year?
Yup there is a Vagrant setup for Kubernetes too! You can find it at [github.com/cloudnativehero/kubeadm-vagrant](https://github.com/cloudnativehero/kubeadm-vagrant)

## Want to become a real PRO?

(Do not do this... like really don't do this unless you do this for a living)

So you want to brag to your friends you know Kubernetes *really, really* well? Go set up a cluster using [Kelsey Hightower's Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way).

[^bashbatter]: Eyskens, Mariën. (2022). Bash vs. PowerShell. B300 fights.
