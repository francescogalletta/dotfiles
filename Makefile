.PHONY: sync test check

sync:
	@./sync.sh

test:
	@./test.sh

check: sync test
