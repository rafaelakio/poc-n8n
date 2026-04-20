.PHONY: help install test lint format clean up down logs validate-compose validate-json validate-terraform

help:
	@echo "Targets disponíveis:"
	@echo "  install   - Instala ferramentas de desenvolvimento (pre-commit, shellcheck, jq)"
	@echo "  test      - Executa toda a suíte de testes (compose, JSON, terraform)"
	@echo "  lint      - Roda pre-commit em todos os arquivos"
	@echo "  format    - Formata arquivos terraform (terraform fmt -recursive)"
	@echo "  clean     - Remove artefatos locais (volumes docker, .terraform)"
	@echo "  up        - Sobe o stack docker-compose (n8n local)"
	@echo "  down      - Derruba o stack docker-compose"
	@echo "  logs      - Exibe logs do docker-compose"

install:
	@pip install --user pre-commit || true
	@pre-commit install || true
	@echo "Certifique-se de ter jq e shellcheck instalados (sudo apt-get install -y jq shellcheck)."

test: validate-compose validate-json validate-terraform
	@echo "Todos os testes passaram."

validate-compose:
	@bash tests/test_docker_compose.sh

validate-json:
	@bash tests/test_workflows_json.sh

validate-terraform:
	@bash tests/test_terraform.sh

lint:
	@pre-commit run --all-files || true

format:
	@command -v terraform >/dev/null 2>&1 && terraform fmt -recursive terraform/ || echo "terraform não instalado; pulando format."

clean:
	@docker compose down -v --remove-orphans || true
	@find terraform -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	@find terraform -type f -name ".terraform.lock.hcl" -delete 2>/dev/null || true

up:
	@docker compose up -d

down:
	@docker compose down

logs:
	@docker compose logs -f
