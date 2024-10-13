## Single-Node OKD cluster

This project creates an ISO image with a Single-Node OKD cluster. The ISO file is generated using Docker and the build process is automated through a Makefile. Upon completion, the Makefile outputs a `./out/` folder containing the `okd.iso` file, as well as an `auth` subfolder with `kubeconfig` and `kubeadmin-password`.

### Pre-requisites
Before running the Makefile, you must update the `install-config.yaml` file with your SSH key and set the `baseDomain` to your server's domain name. Ensure that the domain supports wildcards to allow for subdomains.

### Testing the ISO
To test the `okd.iso` file, create a virtual machine (VM) in Proxmox with at least:
- 40GB disk space
- 20GB RAM

The installation process takes approximately 20 minutes, and the VM will reboot several times throughout.

### Accessing the OpenShift Console
Once the installation is complete and the cluster is running, you can obtain the URL for the OpenShift Console by running the following command:
```
oc get routes -n openshift-console
```

### Deploying Applications
To deploy an application (for example, CyberChef), run:
```
oc new-app mpepping/cyberchef
```

To expose the CyberChef service, run:
```
oc expose svc/cyberchef
```

### Getting Routes for All Services
To list the routes for all running services in OKD, use:
```
oc get route --all-namespaces
```

