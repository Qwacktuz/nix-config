# Secrets

## What is configured

`secrets/pubkeys.yaml` now contains all four formerly plaintext `pubkeys/*.pub`
files. System-level sops-nix decrypts them and renders the existing authorized
keys at runtime: the two FIDO keys on every host, plus Saguaro's key on Fishhook.
The Fishhook public key is retained as an encrypted field but is not authorized
anywhere, matching its previous use. Key values are never read during evaluation.

**Before switching any host**, provision and enroll its system identity as
described below. User identities for `home.yaml` and system identities for
`pubkeys.yaml` are separate. The existing user recipients on `pubkeys.yaml`
provide editing access; they do not provision boot-time decryption.

`modules/features/sops.nix` imports the Home Manager sops-nix module on all
four hosts through `profile-cli`. The input is pinned in `flake.lock` and follows
the existing nixpkgs input. It works with Linux user systemd and macOS launchd.

`secrets/home.yaml` contains the private SSH host configuration and Obsidian
workspace paths. Each value is encrypted; its field name and public age
recipients remain visible. Home Manager decrypts it on activation/login into
the user's runtime secret directory, with mode `0600`, and maintains links at:

```text
~/.config/sops-nix/secrets/ssh_config
~/.config/sops-nix/secrets/obsidian_workspaces
```

SSH includes the first file before its public defaults; Neovim reads the second
at runtime. Neither consumer reads plaintext during Nix evaluation. The Nix
store receives ciphertext and runtime paths, never decrypted values.

The configured age identity is a runtime **string** path:
`~/.config/sops/age/keys.txt`. `SOPS_AGE_KEY_FILE` points there for the CLI on
both platforms, avoiding macOS SOPS's different default search directory.
Existing shells need to export this variable until the next login.
Automatic user identity generation and user SSH-key autodiscovery are disabled.
System SOPS instead imports the explicit SSH host key path described below.

Saguaro's existing local age identity is the personal recipient for `home.yaml`.
Restore that personal identity from its secure backup on user accounts that
need these secrets, or enroll a separate user identity using the procedure below.
Builds require no
private key; runtime decryption on an unenrolled host will fail.

The inaccessible legacy `secrets/secrets.yaml` and its recipient rules were
removed. Its values were not recovered or migrated; older Git revisions still
contain its ciphertext. The active file is `secrets/home.yaml`, encrypted for
Saguaro's current `~/.config/sops/age/keys.txt` identity.

Git uses macOS Keychain, or a one-hour in-memory credential cache on Linux.
Existing `~/.git-credentials` files are not automatically migrated or deleted.
Reauthenticate with the new helper, then remove any obsolete plaintext store.

## How encryption works

SOPS generates a random data key to encrypt file values. That data key is
wrapped separately for each listed age recipient. Any one matching private age
identity can decrypt the **entire file**. `.sops.yaml` contains public recipients
and creation rules, not private identities. Changing it alone does not update
already-encrypted files; use `sops updatekeys`.

Keep unique SSH host identities per machine and an offline recovery identity.
The personal age identity may be shared across your own user accounts; use
separate user identities if independent device revocation is required.
Everyone listed on `home.yaml`
can read its whole payload; put server-only service credentials in separate
host files with only that server and recovery recipients. Enroll a machine only
if it should receive every value in the selected file.

Do not put the age private identity inside the SOPS file it decrypts. Keep it
outside this repository and the Nix store, mode `0600`, with its directory mode
`0700`. Back it up in an encrypted password manager or offline encrypted backup.
Disk encryption protects the local identity and runtime plaintext at rest;
SOPS does not protect a running account from processes with the same access.

## Enroll another machine

On the target, generate a fresh **user** identity; do not overwrite an existing
one. `age-keygen -o` refuses to replace a file that exists.

```bash
umask 077
mkdir -p "$HOME/.config/sops/age"
chmod 700 "$HOME/.config/sops/age"
age-keygen -o "$HOME/.config/sops/age/keys.txt"
chmod 600 "$HOME/.config/sops/age/keys.txt"
age-keygen -y "$HOME/.config/sops/age/keys.txt"
```

Transfer only the printed `age1...` **public recipient** to the editing machine.
Add a named anchor in `.sops.yaml` and list it under the `secrets/home.yaml`
creation rule. On Saguaro (which can currently decrypt):

```bash
export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"
sops updatekeys secrets/home.yaml
```

Transfer/pull the updated ciphertext to the target and verify access without
printing the plaintext:

```bash
export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"
sops --decrypt secrets/home.yaml >/dev/null
```

Back up each identity before deploying. Add an offline recovery public recipient
to the same rule, then run `updatekeys` again. Keep that recovery private key
off the machines it is intended to recover.

## Provision system identities for encrypted authorized keys

System SOPS derives its age identity from the existing root-owned SSH Ed25519
host key at `/etc/ssh/ssh_host_ed25519_key`. No persistent system `keys.txt`
is required. User SOPS still uses `~/.config/sops/age/keys.txt`.

On each host, generate missing SSH host keys without replacing existing ones,
then derive the public age recipient:

```bash
sudo /usr/bin/ssh-keygen -A # macOS; use sudo ssh-keygen -A on NixOS
nix run nixpkgs#ssh-to-age -- -i /etc/ssh/ssh_host_ed25519_key.pub
```

Back up the private SSH host key securely. Add only the printed public age
recipient to `.sops.yaml`, under the `secrets/pubkeys.yaml` rule. On an already
authorized editing machine:

```bash
SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt" \
  sops updatekeys secrets/pubkeys.yaml
```

Transfer the updated ciphertext to the target. With `ssh-to-age` and `sops`
available, test using only the host identity (the private conversion is piped,
never saved to a file):

```bash
sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key | \
  SOPS_AGE_KEY_FILE=/dev/stdin sops decrypt secrets/pubkeys.yaml >/dev/null
```

Saguaro and Luna's SSH-derived recipients are enrolled for `pubkeys.yaml`.
Enroll Fishhook and Cholla's actual SSH-derived recipients before switching.
The host-only decryption test on Saguaro requires interactive sudo authentication
and has not been completed by the agent.

Only switch after this succeeds. Keep an existing SSH session and console access
available during the first switch, then verify a second SSH login before closing
the session. No activation or SSH host-key replacement was performed by this change.

System SOPS runs during activation and boot, independently of Home Manager or
user login. It renders `/etc/ssh/authorized_keys.d/kaktus` on NixOS and
`/etc/ssh/nix_authorized_keys.d/kaktus` on macOS, preserving each platform's
existing SSH lookup. The rendered public-key file is root-owned, mode `0444`,
because macOS reads it through an `_sshd` command. Its source values and other
decrypted SOPS fields remain root-only; authorized public keys are readable at
runtime. This hides current Git source values, not keys already in Git history
or keys visible to the running system.

Edit key fields with `sops edit secrets/pubkeys.yaml`. The system template combines
the FIDO fields; Fishhook appends the Saguaro field. Add a new field's declaration
and template placeholder in `modules/features/core.nix` to authorize a new key.

The two user secrets were also installed once on Saguaro to verify runtime
decryption and permissions. A full system switch is still needed to install the
persistent launchd agent, new SSH include, and Git settings.

Stage the new module, encrypted file, checks, and documentation before running a
normal Git-flake build; Nix excludes untracked files. Review `git diff --cached`.
Then run the checks and your usual target switch:

```bash
nix build .#checks.aarch64-darwin.secrets .#checks.aarch64-darwin.profile-policy
nh darwin switch # on macOS
# nh os switch  # on NixOS
```

The existing `profile-policy` check currently fails its Homebrew activation
assertion on the unchanged baseline too. The new focused `secrets` check passes;
that pre-existing policy failure needs separate resolution before all checks pass.

Check decryption after activation/login:

```bash
# Linux
systemctl --user status sops-nix.service
# macOS
launchctl print "gui/$(id -u)/org.nix-community.home.sops-nix"
test -r "$HOME/.config/sops-nix/secrets/ssh_config"
```

On NixOS, these user secrets become available with the user session. Services
that need secrets before login must use the NixOS sops-nix module and a separate
host identity/file, with explicit service ownership and restart ordering.
Do not use this user module for boot-time passwords or system services.

## Edit or add secrets

### SSH client keys and Proton Pass

MacBooks use the Proton Pass CLI agent with the `Dev` vault. Log in once with
`pass-cli login` on each MacBook. Home Manager starts the agent at login and
refreshes vault keys every five minutes. Encrypted SSH key items need a Hidden
custom field named `Passphrase` containing the key passphrase.

`ssh-private-keys` now deploys only the 21 public `.pub` selectors and two FIDO
`*_sk` handles from `secrets/ssh.yaml`. Software private keys remain encrypted in
that file for recovery but are no longer declared as SOPS runtime secrets.
Activation removes old software-private-key links only when they point to the
expected SOPS runtime paths; independent regular files are left untouched.

Darwin uses `ssh_config_proton` in `secrets/home.yaml`, with software
`IdentityFile` entries pointing to `.pub` files. Linux retains `ssh_config`.
`IdentitiesOnly yes` selects the matching agent key rather than offering every
vault key. Import software keys into Proton Pass before activating this change;
this configuration does not upload private keys or passphrases.

FIDO handles still require their physical security keys and touch/PIN. The
personal age identity is still required to decrypt the public selectors, handles,
and other SOPS-managed configuration during activation.

```bash
nh darwin switch
ssh-add -l
ssh -T git@github.com
```

### Other application secrets

```bash
export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"
sops secrets/home.yaml
```

Use an editor with swap, undo, backup files, and cloud sync disabled for the
decrypted buffer. SOPS decrypts temporarily for editing; editor recovery files
can otherwise retain plaintext. Do not export decrypted files into this repo.
Avoid copying secret values into shell command arguments or shell history.

To deploy a new field, add its encrypted value using SOPS, declare
`sops.secrets.<field>`, and point the application at `config.sops.secrets.<field>.path`.
Use the application's credentials-file option. For configuration that must
contain a secret value, use sops-nix runtime templates/placeholders, never
`builtins.readFile`, `home.file.text`, `environment.etc.text`, `writeText`, or a
derivation that decrypts it. Never export secret values via Nix session variables.

Do not distribute private client keys to every host. FIDO/YubiKey keys remain
hardware backed; SOPS is not a replacement for the authenticator.

## Rotation, recovery, and publication

When adding recipients, `sops updatekeys secrets/home.yaml` rewraps the data key.
When removing one, remove its public recipient, run `updatekeys`, then run
`sops rotate --in-place secrets/home.yaml` with a remaining authorized identity.
If an identity or credential was exposed, also rotate the underlying credentials
and revoke their old authorizations. Old Git revisions remain decryptable with
old identities; changing recipients cannot revoke copies already obtained.

The private key files found in Git history still need a separate history cleanup:
`pubkeys/kaktus_id_ed25519_sk` and `pubkeys/kaktus_id_ed25519_sk_backup`.
Encrypting today's files does not remove those historical copies. This change
does not rewrite or force-push history. Clean it before making the repo public;
replace affected credentials if those files were previously exposed.

The pre-commit Gitleaks hook and `checks.secrets` scan current source without
decryption. The check also rejects unencrypted values in `secrets/**/*.yaml`.
They do not certify Git history; scan that separately before publication.

Age recipients, disk UUIDs, hostnames, the configured network domain,
and the GitHub noreply identity remain public configuration identifiers. They
are not authentication secrets. Hiding the network domain would require a
runtime consumer redesign or keeping that host configuration private; reading
it from SOPS during Nix evaluation would expose it in the Nix store.

References: [sops-nix](https://github.com/Mic92/sops-nix),
[Home Manager runtime implementation](https://github.com/Mic92/sops-nix/blob/master/modules/home-manager/sops.nix),
[SOPS key management](https://github.com/getsops/sops#key-management).
