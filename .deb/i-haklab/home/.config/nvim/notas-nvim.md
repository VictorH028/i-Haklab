# Informe: Notas sobre Neovim en Termux

**Fecha:** 2026-10-11
**Entorno:** Termux (Android) + Neovim
**Autor:** @demonr_rip

---

## 1. Problema: `plenary.nvim` intenta acceder a la raíz `/tmp`

### Síntoma

Al ejecutar `:CodeCompanionChat`, aparece un error similar a:
```
    plenary.nvim/lua/plenary/curl.lua:310: 
    get http://localhost:11434/api/tags - curl error exit_code=23
    stderr={ "curl: Failed to open /tmp/plenary_curl_030f428e.headers",
            "curl: (23) Failed writing received data to disk/application" }
```
### Causa

`plenary.nvim` intenta escribir archivos temporales en `/tmp`, pero en Termux
ese directorio no es escribible por el sandbox de Android. La variable `TMPDIR`
no es respetada por el módulo `curl` de `plenary.nvim`.

### Solución

Definir la variable de entorno `XDG_RUNTIME_DIR` apuntando al directorio
temporal de Termux:

```bash
export XDG_RUNTIME_DIR="$PREFIX/tmp"
```
