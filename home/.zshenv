# Omarchy: OMARCHY_PATH and PATH for every zsh, including non-interactive `ssh host cmd`.
if [[ -r /usr/share/omarchy/default/bash/env-bootstrap ]]; then
  emulate sh -c '. /usr/share/omarchy/default/bash/env-bootstrap'
fi
