## help: display this message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##\s//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/    /'

## switch: apply the configuration
switch:
	@scripts/switch
