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



## Air-Gapped Container Registry for OKD

The subfolder **airGappedContainerRegistry** offers a straightforward method to create an **air-gapped Docker registry** loaded with OKD (Origin Kubernetes Distribution) images. It's designed to help you deploy OKD in environments without internet access by bundling all necessary container images into a single, portable Docker image.

## Overview

The makefile automates the process of:

- **Setting up a local Docker registry** using Docker Compose.
- **Mirroring OKD release images** from the public registry to your local registry.
- **Packaging the registry** with all mirrored images into a Docker image called `okdregistry`.

## Usage

1. **Build the Air-Gapped Registry Image**:

   ```bash
   make
   ```

   This command will set up the local registry, mirror the OKD images, and build the `okdregistry` Docker image containing all necessary components.

2. **Deploy in an Air-Gapped Environment**:

   - Transfer the `okdregistry` image to your air-gapped environment.
   - Run the Docker image:

     ```bash
     docker run -d -p 5000:5000 okdregistry
     ```

3. **Update the OKD Install Configuration**:

     Extend your `install-config.yaml` file with the following `imageContentSources` configuration:

     ```yaml
     imageContentSources:
     - mirrors:
       - localhost:5000/openshift/okd
       source: quay.io/openshift/okd
     - mirrors:
       - localhost:5000/openshift/okd
       source: quay.io/openshift/okd-content
     ```

     This tells the OKD installer to pull images from your local registry instead of the public registry.

   - Proceed with the OKD installation, ensuring that it references your local registry at `localhost:5000/openshift/okd`.

## Notes

- **Ports**: Ensure that port `5000` is available on your system, as it is used by the local Docker registry.
- **Prerequisites**: Docker and Docker Compose should be installed on the system where you build and run the registry.
- **OKD Tools**: The process involves using the `oc` command-line tool to mirror images.
