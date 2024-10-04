library(reticulate)
source('utils.R')

setup_virtual_environment <- function(PYTHON_VERSION = '3.10.12', 
                                      PYTHON_DEPENDENCIES = c('joblib'), 
                                      VIRTUALENV_DIR = './python_virtualenv') {
  
  if (!dir.exists(VIRTUALENV_DIR)) {
    cat(timestamp(), "[INFO]", "Ambiente virtual não encontrado. Criando o ambiente virtual em", VIRTUALENV_DIR, "...\n")
    tryCatch({
      reticulate::virtualenv_create(envname = VIRTUALENV_DIR, python = reticulate::virtualenv_starter(PYTHON_VERSION))
      cat(timestamp(), "[INFO]", "Ambiente virtual criado com sucesso. Python versão:", PYTHON_VERSION, "\n")
    }, error = function(e) {
      cat(timestamp(), "[ERROR]", "Falha ao criar o ambiente virtual:", e$message, "\n")
      stop("[CRITICAL ERROR] Não foi possível criar o ambiente virtual.")
    })
    
    cat(timestamp(), "[INFO]", "Instalando dependências no ambiente virtual:", PYTHON_DEPENDENCIES, "...\n")
    tryCatch({
      reticulate::virtualenv_install(VIRTUALENV_DIR, packages = PYTHON_DEPENDENCIES, ignore_installed = TRUE)
      cat(timestamp(), "[INFO]", "Dependências instaladas com sucesso.\n")
    }, error = function(e) {
      cat(timestamp(), "[ERROR]", "Falha ao instalar dependências:", e$message, "\n")
      stop("[CRITICAL ERROR] Não foi possível instalar as dependências.")
    })
  } else {
    cat(timestamp(), "[INFO]", "Ambiente virtual existente encontrado em", VIRTUALENV_DIR, ". Usando o ambiente existente...\n")
  }
  
  tryCatch({
    reticulate::use_virtualenv(VIRTUALENV_DIR, required = TRUE)
    cat(timestamp(), "[INFO]", "Ambiente virtual ativado com sucesso.\n")
  }, error = function(e) {
    cat(timestamp(), "[ERROR]", "Falha ao ativar o ambiente virtual:", e$message, "\n")
    stop("[CRITICAL ERROR] Não foi possível ativar o ambiente virtual.")
  })
}
