# Temporary root SSH access

Use this only when privileged remote diagnostics or remediation cannot be performed through the `yom` account. The agent using the temporary key must remove it itself as soon as the work is verified; it must not leave cleanup to the user.

## Grant access

1. On the client that needs access, print the public key:

   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

2. Connect as `yom`:

   ```bash
   ssh yom@pve.internal.yomitosh.media
   ```

3. On the Proxmox host, append that public key to root's authorized keys. Replace `<public-key>` with the complete line printed in step 1:

   ```bash
   sudo install -d -m 700 /root/.ssh
   printf '%s\n' '<public-key>' | sudo tee -a /root/.ssh/authorized_keys >/dev/null
   sudo chmod 600 /root/.ssh/authorized_keys
   ```

   Append the key; do not overwrite `authorized_keys`, because it may contain access for other administrators.

4. From the client, verify access:

   ```bash
   ssh -o BatchMode=yes root@pve.internal.yomitosh.media true
   ```

## Remove access

The agent must remove its own key while root access is still available. From the client, replace `<public-key>` with the exact complete line added above and run:

```bash
ssh root@pve.internal.yomitosh.media \
  'tmp=$(mktemp); grep -Fvx -- "<public-key>" /root/.ssh/authorized_keys >"$tmp" || true; install -m 600 "$tmp" /root/.ssh/authorized_keys; rm -f "$tmp"'
```

The automated command removes only exact matches for the temporary public-key
line and preserves all other administrators' keys.

### Manual removal

If the automated command cannot be used, reconnect as `yom` and edit root's
authorized keys manually:

```bash
ssh -t yom@pve.internal.yomitosh.media 'sudoedit /root/.ssh/authorized_keys'
```

Delete only the exact public-key line added for temporary access. Do not remove
any other administrator's key.

After either removal method, the agent must verify that its temporary key is rejected:

```bash
ssh -o BatchMode=yes -o ConnectTimeout=5 root@pve.internal.yomitosh.media true
```

Expected result:

```text
root@pve.internal.yomitosh.media: Permission denied (publickey,password).
```

If root access still succeeds, check whether the same key appears more than once or is authorized by another SSH configuration source.
