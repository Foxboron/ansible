RELEASE="14.2"
wget https://github.com/home-assistant/operating-system/releases/download/${RELEASE}/haos_ova-${RELEASE}.qcow2.xz
# extract it
xz -d haos_ova-${RELEASE}.qcow2.xz
# make a `metadata.yaml` file and compress it
cat << EOF > metadata.yaml 
architecture: x86_64
creation_date: $(date +%s)
properties:
  description: Home Assistant image ${RELEASE}
  os: Debian
  release: ${RELEASE}
EOF
tar -cvzf metadata.tar.gz metadata.yaml
incus image import metadata.tar.gz haos_ova-${RELEASE}.qcow2 --alias "haos-${RELEASE}"
