SRC   := src/*.el src/checkers/*.el
EMACS ?= emacs --eval '(add-to-list (quote load-path) (concat default-directory "src/"))'

.PHONY: lint
lint: compile checkdoc

.PHONY: checkdoc
checkdoc: ## Check for missing or poorly formatted docstrings
	@for file in $(SRC); do \
	    echo "[checkdoc] $$file" ;\
	    $(EMACS) -Q --batch \
	        --eval "(or (fboundp 'checkdoc-file) (kill-emacs))" \
	        --eval "(setq sentence-end-double-space nil)" \
	        --eval "(checkdoc-file \"$$file\")" 2>&1 \
	        | grep . && exit 1 || true ;\
	done

.PHONY: compile
compile: ## Check for byte-compiler errors
	@for file in $(SRC); do \
	    echo "[compile] $$file" ;\
	    rm -f "$${file}c" ;\
	    $(EMACS) -Q --batch -L . -f batch-byte-compile $$file 2>&1 \
	        | grep -v "^Wrote" \
	        | grep . && exit 1 || true ;\
	done

.PHONY: docker-build
docker-build: ## Create a build image for running tests
	@echo "[docker] Building docker image"
	@docker build  -t flymake-collection-test ./tests/checkers

DOCKER_COMMAND := bash
DOCKER_FLAGS := -it
.PHONY: docker
docker: docker-build ## Run a command in the built docker-image.
	@docker run \
	  --rm \
	  $(DOCKER_FLAGS) \
      --workdir /workspaces/flymake-collection \
	  --volume "$$(pwd)":/workspaces/flymake-collection:ro \
	  flymake-collection-test \
	  $(DOCKER_COMMAND)

.PHONY: test
test: ## Run all defined test cases.
	@echo "[test] Running all test cases"
	@find ./tests/checkers/test-cases/ -iname '*.yml' | parallel -I{} chronic ./tests/checkers/run-test-case {}

.PHONY: clean
clean: ## Remove build artifacts
	@echo "[clean]" $(subst .el,.elc,$(SRC))
	@rm -f $(subst .el,.elc,$(SRC))
