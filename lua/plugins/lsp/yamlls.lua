local util = require("util")

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  cmd = { "/usr/local/bin/node", vim.fs.joinpath(util.src_path("github.com/redhat-developer/yaml-language-server/bin/yaml-language-server")), "--stdio" }, -- disabled "Matches multiple schemas when only one must validate." error
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  settings = {
    yaml = {
      yamlVersion = 1.2,
      format = {
        enable = true,
        singleQuote = false,
        bracketSpacing = true,
        proseWrap = "preserve",
        printWidth = 150,
      },
      validate = true,
      hover = true,
      completion = true,
      maxItemsComputed = 50000,
      suggest = {
        parentSkeletonSelectedFirst = true,
      },
      schemaStore = {
        enbale = true,
        url = "https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/api/json/catalog.json",
      },
      disableAdditionalProperties = false,
      customTags = {
        -- for mkdocs
        "tag:yaml.org,2002:python/name:pymdownx.slugs.uslugify",
        "tag:yaml.org,2002:python/name:pymdownx.superfences.fence_code_format",
        "tag:yaml.org,2002:python/object/apply:pymdownx.arithmatex.arithmatex_fenced_format",
        "tag:yaml.org,2002:python/object/apply:pymdownx.arithmatex.arithmatex_inline_format",
        "tag:yaml.org,2002:python/name:material.extensions.emoji.twemoji",
        "tag:yaml.org,2002:python/name:material.extensions.emoji.to_svg",
      },
      schemas = {
        -- local : zchee/schema
        --- Buf
        ["file:///Users/zchee/src/github.com/zchee/schema/buf.schema.json"] = {
          "buf*.yaml",
          "!buf.gen.*.yaml",
        },
        ["file:///Users/zchee/src/github.com/zchee/schema/buf.gen.schema.json"] = {
          "buf.gen.yaml",
          "buf.gen.*.yaml",
        },
        --- Cloud Endpoints
        ["file:///Users/zchee/src/github.com/zchee/schema/service.schema.json"] = {
          "*.endpoints.yaml",
        },
        --- knative.dev
        ["file:///Users/zchee/src/github.com/zchee/schema/Revision.serving.knative.dev.json"] = {
          "*.knative.yaml",
        },
        --- kaitai-struct-compiler
        ["file:///Users/zchee/src/github.com/zchee/schema/kaitai-struct-compiler.schema.json"] = {
          "*.ksy",
        },
        --- open-rpc
        ["file:///Users/zchee/src/github.com/zchee/schema/open-rpc.schema.json"] = {
          "openrpc.yaml",
        },
        -- codecov
        ["file:///Users/zchee/src/github.com/zchee/schema/codecov.json"] = {
          "*codecov.yml",
          "*codecov.yaml",
        },
        -- ocb
        ["file:///Users/zchee/src/github.com/zchee/schema/opentelemetry-collector-builder.schema.json"] = {
          "otelcol.yaml",
        },
        --- mkdocs
        -- ["file:///Users/zchee/src/github.com/zchee/schema/mkdocs.schema.json"] = {
        --   "mkdocs.yml",
        -- },

        -- apko
        ["https://raw.githubusercontent.com/chainguard-dev/apko/main/pkg/build/types/schema.json"] = {
          "*.apko.yaml",
          "apko.yaml",
        },
        -- azure-pipelines
        ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/main/service-schema.json"] = {
          "azure-pipelines.yml",
        },
        -- compose
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
          "*compose*.yaml",
          "*compose*.yml",
          "*docker-compose*.yaml",
          "*docker-compose*.yml",
        },
        -- discovery (disco)
        ["https://raw.githubusercontent.com/googleapis/gnostic/master/discovery/discovery.json"] = {
          "*discovery.yaml",
        },
        -- OpenAPI
        ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = {
          "*openapi*.yaml",
          "**/openapi-spec/*.yaml",
        },
        -- skaffold
        ["https://raw.githubusercontent.com/GoogleContainerTools/skaffold/main/docs-v2/content/en/schemas/v3alpha1.json"] = {
          "skaffold*.yaml",
        },
        -- swagger
        ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v2.0/schema.json"] = {
          "*swagger.yaml",
          "**/swagger-spec/*.yaml",
        },
        -- renovate
        ["https://docs.renovatebot.com/renovate-schema.json"] = {
          "renovate.json",
          "renovate.json5",
          ".renovaterc",
          ".renovaterc.json",
        },
        -- helm charts
        ["https://raw.githubusercontent.com/open-telemetry/opentelemetry-helm-charts/main/charts/opentelemetry-operator/values.schema.json"] = {
          "opentelemetry-operator/values.yaml",
        },

        -- SchemaStore
        -- appveyor
        ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/appveyor.json"] = {
          "*appveyor.yml",
        },
        -- circleci
        ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/circleciconfig.json"] = {
          ".circleci/config.yml",
          ".circleci/config.yaml",
        },
        -- clang-format
        ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/clang-format.json"] = {
          ".clang-format",
        },
        -- clangd
        ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/clangd.json"] = {
          ".clangd",
          "*clangd/config.yaml",
          -- vim.fs.joinpath(vim.fn.resolve(os.getenv("$XDG_CONFIG_HOME")), "clangd/config.yaml"),
        },
        -- cloudbuild
        ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/cloudbuild.json"] = {
          "*cloudbuild.yaml",
          "*cloudbuild.*.yaml",
        },
        -- compile-commands.json
        ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/compile-commands.json"] = {
          "compile_commands.json",
        },
        -- dependabot
        ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/dependabot-2.0.json"] = {
          ".github/dependabot.yaml",
          ".github/dependabot.yml",
        },
        -- github-action
        ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/github-action.json"] = {
          "*/action.yml",
          "*/action.yaml",
          "**/action.yml",
          "**/action.yaml",
        },
        -- github-issue-forms
        ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/github-issue-forms.json"] = {
          ".github/ISSUE_TEMPLATE/*.yml",
          ".github/ISSUE_TEMPLATE/*.yaml",
        },
        -- github-issue-config
        ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/github-issue-config.json"] = {
          ".github/ISSUE_TEMPLATE/config.yml",
          ".github/ISSUE_TEMPLATE/config.yaml",
        },
        -- github-workflow-templates
        ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/github-workflow-template-properties.json"] = {
          ".github/workflow-templates/*.yml",
          ".github/workflow-templates/*.yaml",
        },
        -- github-workflow
        ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/github-workflow.json"] = {
          ".github/workflows/*.yml",
          ".github/workflows/*.yaml",
        },
        -- golangci-lint
        -- ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/golangci-lint.json"] = {
        --   ".golangci.yml",
        --   ".golangci.yaml",
        -- },
        ["https://raw.githubusercontent.com/golangci/golangci-lint/master/jsonschema/golangci.next.jsonschema.json"] = {
          ".golangci.yml",
          ".golangci.yaml",
        },
        -- kustomize
        ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/kustomization.json"] = {
          "kustomization.yaml",
          "kustomizeconfig.yaml",
        },
        -- mkdocs
        ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/mkdocs-1.0.json"] = {
          "mkdocs.yml",
        },
        -- yamllint
        ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/yamllint.json"] = {
          ".yamllint.yaml",
        },
        --- Cloud Workflows
        ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/workflows.json"] = {
          "workflows.yaml",
          "*.workflows.yaml",
          "workflows.yml",
          "*.workflows.yml",
          "workflows-demos/**/*.yaml",
        },

        -- other
        ["https://raw.githubusercontent.com/microsoft/vscode-languageserver-node/main/protocol/metaModel.schema.json"] = {
          "metaModel.yaml",
          "lsp*.yaml",
        },

        -- kubernetes
        -- ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master-standalone-strict/all.json"] = {
        ["kubernetes"] = {
          "clusterrole.yaml",
          "clusterrolebinding.yaml",
          "comfigmap.yaml",
          "cronjob.yaml",
          "daemonset*.yaml",
          "deployment*.yaml",
          "horizontal_pod_autoscaler.yaml",
          "hpa.yaml",
          "ingress.yaml",
          "namespace.yaml",
          "pdb.yaml",
          "pod.yaml",
          "pod_disruption_budget.yaml",
          "poddisruptionbudget.yaml",
          "psp.yaml",
          "rbac.yaml",
          "replicaset.yaml",
          "secret.yaml",
          "secrets*.yaml",
          "service*.yaml",
          "service_account.yaml",
          "serviceaccount.yaml",
          "statefulset*.yaml",
          "gotk-components.yaml", -- fluxcd
        },
      },
    },
  },
  on_new_config = function(new_config, _)
    -- disable format on kustomization.yaml
    if string.find(vim.api.nvim_buf_get_name(0), "kustomization.yaml") then
      new_config.settings.yaml.format.enable = false
    end
  end,
}
