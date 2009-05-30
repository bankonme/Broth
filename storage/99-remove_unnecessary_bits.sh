#!/bin/sh
# Populate system with cleaning hook script

cat > /sbin/pure-cleaning << EOF
#!/bin/sh

echo "starting cleaning"

set -e

#apt-get autoremove --yes || true

# Removing unused files
find . -name *~ -print0 | xargs -0 rm -f

rm -rf /var/cache/man/*

# Cleaning apt lists
rm -rf /var/lib/apt/lists
mkdir -p /var/lib/apt/lists/partial

# Cleaning apt cache
rm -rf /var/cache/apt
mkdir -p /var/cache/apt/archives/partial

# Truncating logs
for FILE in \`find /var/log/ -type f\`
do
	rm \${FILE}
	touch \${FILE}
done

# Suicide
rm /sbin/pure-cleaning
EOF

chmod 0755 /sbin/pure-cleaning
