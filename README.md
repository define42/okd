

oc get routes -n openshift-console

oc new-app mpepping/cyberchef
oc expose svc/cyberchef

oc get route --all-namespaces

