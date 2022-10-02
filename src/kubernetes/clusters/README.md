# Getting "a kube"

Before we get started we need a Kubernetes cluster to use! Several cloud providers offer Kubernetes as a service, but we're going to use [kind](https://kind.sigs.k8s.io/) to create a local cluster to play with first. If you're interested in deploying a multi server solution we'll look into the official Kubernetes distribution [kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/) later.

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

The `kubeconfig` is a file that contains all the information to connect to a Kubernetes cluster. It is a YAML file that contains all the information to connect to one or multiple cluster. It is a file that is often shared between developers to get cluster access but should be considered as a password.

You can find it at `~/.kube/config` on macOS/Linux and `C:\Users\%USERNAME%\.kube\config` on Windows.

## kind - the developer's friend

[kind](https://kind.sigs.k8s.io/docs/user/quick-start/) is a tool to run local Kubernetes clusters using Docker containerss. It is a great tool for developers as it is fast and lightweight compared to other solutions. It is an alternative to [minikube](https://minikube.sigs.k8s.io/docs/start/) which uses VMs under the hood so will be slower.

You can install it with the following command:

```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.16.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

If you need a clustter it is as easy as running `kind create cluster` and you will have a cluster running in a few seconds. You can then interact with it with `kubectl` as you would with any other cluster, the credentials are automatically configured.

Check it out with `kubectl get nodes`:

```bash
$ kubectl get nodes
NAME                 STATUS   ROLES                  AGE   VERSION
kind-control-plane   Ready    control-plane,master   10s   v1.22.2
```

When you are done you can delete the cluster with `kind delete cluster`.

When we use kind in class it is a good idea to enable ingress support so we can use HTTP/HTTPS routing. You can do this with the following command:

```bash
cat <<EOF | kind create cluster --config=-
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
EOF
```

### Ingress

```bash
# Now let's install our ingress controller compoment
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
kubectl get pod --all-namespaces # watch to see them all starting
```

### Storage

## kubeadm - the production ready offcial way

### The local multi VM cluster? Vagrant of course!

https://github.com/cloudnativehero/kubeadm-vagrant

## Want to become a real PRO?

(Do not do this... like really don't do this unless you do this for a living)

So you want to brag to your friends you know Kubernetes really really well? Go set up a cluster using [Kelsey Hightower's Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way).

[^bashbatter]: Eyskens, Mariën. (2022). Bash vs. PowerShell. B300 cage fights.
