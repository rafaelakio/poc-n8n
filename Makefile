.PHONY: test test-json test-docker

test: test-json test-docker

test-json:
	@echo "Validando arquivos JSON..."
	bash ./tests/test_workflows_json.sh

test-docker:
	@echo "Validando Docker Compose..."
	bash ./tests/test_docker_compose.sh