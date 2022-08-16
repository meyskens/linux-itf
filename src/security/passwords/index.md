# Passwords

Passwords are used everywhere in this world. But when we start thinking about our servers we have to start being careful with passwords.
Passwords are easy to figure out in far too many cases.

## How long until we can guess your password?

Let's take a look at [password haystacks](https://www.grc.com/%5Chaystack.htm). This is going to calculate how long **1 computer** is going to take to brute fork your password, and doesn't take into account lists of leaked passwords or word books!

![haystack](./haystack.png)

## Are you for sale on the dark web?

For a few bucks, you can buy a list of passwords coming from poorly secured websites on the dark web. As luck would have it, we also have real data collectors who use these for good.

[Have I been pwned?](https://haveibeenpwned.com/) has a collection maintained by security researcher Troy Hunt. This is now a well-known database that is also used by other services for alerts.

_Prices not to be checked with your instructor_

## Tips

- Make sure you choose a secure password.
- Limit the number of attempts with tools like [Fail2Ban](https://www.fail2ban.org/)
- Generate random passwords

Long story short... we repeated this part from cybersecurity because we would probably never want to use a password to secure our servers...
We will work with [SSH Keys](/security/ssh-keys) instead
