module.exports = function (plop) {
  plop.setGenerator("cubic", {
    description: "Crea un Cubit + State en un módulo especificado",
    prompts: [
      {
        type: "input",
        name: "module",
        message: "¿En qué módulo o feature lo quieres? (ej: auth, home)",
      },
      {
        type: "input",
        name: "name",
        message: "¿Qué nombre tendrá el Cubit? (ej: login, theme, splash)",
      },
      {
        type: "list",
        name: "stateType",
        message: "¿Qué tipo de estado quieres usar?",
        choices: [
          {
            name: "Sealed State (initial, loading, error, loaded)",
            value: "sealed",
          },
          {
            name: "Single State (un estado con múltiples propiedades)",
            value: "single",
          },
        ],
      },
    ],
    actions: function (data) {
      const actions = [];
      
      if (data.stateType === "sealed") {
        actions.push({
          type: "add",
          path: "lib/features/{{dashCase module}}/presentation/cubit/{{snakeCase name}}/{{snakeCase name}}_cubit.dart",
          templateFile: "plop-templates/feature/cubit.dart.hbs",
          force: true,
        });
        actions.push({
          type: "add",
          path: "lib/features/{{dashCase module}}/presentation/cubit/{{snakeCase name}}/{{snakeCase name}}_state.dart",
          templateFile: "plop-templates/feature/sealed_state.dart.hbs",
          force: true,
        });
      } else {
        actions.push({
          type: "add",
          path: "lib/features/{{dashCase module}}/presentation/cubit/{{snakeCase name}}/{{snakeCase name}}_cubit.dart",
          templateFile: "plop-templates/feature/single_cubit.dart.hbs",
          force: true,
        });
        actions.push({
          type: "add",
          path: "lib/features/{{dashCase module}}/presentation/cubit/{{snakeCase name}}/{{snakeCase name}}_state.dart",
          templateFile: "plop-templates/feature/single_state.dart.hbs",
          force: true,
        });
      }
      
      return actions;
    },
  });

  plop.setGenerator("feature", {
    description: "Crea un módulo completo con su estructura básica",
    prompts: [
      {
        type: "input",
        name: "name",
        message: "¿Qué nombre tendrá el módulo? (ej: products, orders)",
      },
      {
        type: "list",
        name: "stateType",
        message: "¿Qué tipo de estado quieres usar?",
        choices: [
          {
            name: "Sealed State (initial, loading, error, loaded)",
            value: "sealed",
          },
          {
            name: "Single State (un estado con múltiples propiedades)",
            value: "single",
          },
        ],
      },
    ],
    actions: function (data) {
      const actions = [
        // Domain Layer
        {
          type: "add",
          path: "lib/features/{{snakeCase name}}/domain/entities/{{snakeCase name}}/{{snakeCase name}}.dart",
          templateFile: "plop-templates/feature/entity.dart.hbs",
          force: true,
        },
        {
          type: "add",
          path: "lib/features/{{snakeCase name}}/domain/repositories/{{snakeCase name}}_repository.dart",
          templateFile: "plop-templates/feature/repository.dart.hbs",
          force: true,
        },
        {
          type: "add",
          path: "lib/features/{{snakeCase name}}/domain/usecases/get_all_{{snakeCase name}}s.dart",
          templateFile: "plop-templates/feature/usecase.dart.hbs",
          force: true,
        },
        // Data Layer
        {
          type: "add",
          path: "lib/features/{{snakeCase name}}/data/datasources/remote/{{snakeCase name}}_remote_datasource.dart",
          templateFile: "plop-templates/feature/remote_datasource.dart.hbs",
          force: true,
        },
        {
          type: "add",
          path: "lib/features/{{snakeCase name}}/data/repositories/{{snakeCase name}}_repository_impl.dart",
          templateFile: "plop-templates/feature/repository_impl.dart.hbs",
          force: true,
        },
        // Presentation Layer - Pages
        {
          type: "add",
          path: "lib/features/{{snakeCase name}}/presentation/pages/{{snakeCase name}}/{{snakeCase name}}_page.dart",
          templateFile: "plop-templates/feature/page.dart.hbs",
          force: true,
        },
        {
          type: "add",
          path: "lib/features/{{snakeCase name}}/presentation/pages/{{snakeCase name}}/widgets/.gitkeep",
          force: true,
        },
        // DI
        {
          type: "add",
          path: "lib/features/{{snakeCase name}}/di/{{snakeCase name}}_module.dart",
          templateFile: "plop-templates/feature/module.dart.hbs",
          force: true,
        },
      ];

      // Add state-specific files
      if (data.stateType === "sealed") {
        actions.push({
          type: "add",
          path: "lib/features/{{snakeCase name}}/presentation/cubit/{{snakeCase name}}/{{snakeCase name}}_cubit.dart",
          templateFile: "plop-templates/feature/cubit.dart.hbs",
          force: true,
        });
        actions.push({
          type: "add",
          path: "lib/features/{{snakeCase name}}/presentation/cubit/{{snakeCase name}}/{{snakeCase name}}_state.dart",
          templateFile: "plop-templates/feature/sealed_state.dart.hbs",
          force: true,
        });
      } else {
        actions.push({
          type: "add",
          path: "lib/features/{{snakeCase name}}/presentation/cubit/{{snakeCase name}}/{{snakeCase name}}_cubit.dart",
          templateFile: "plop-templates/feature/single_cubit.dart.hbs",
          force: true,
        });
        actions.push({
          type: "add",
          path: "lib/features/{{snakeCase name}}/presentation/cubit/{{snakeCase name}}/{{snakeCase name}}_state.dart",
          templateFile: "plop-templates/feature/single_state.dart.hbs",
          force: true,
        });
      }

      return actions;
    },
  });

  plop.setGenerator("basic-app", {
    description: "Crea la estructura básica de una app Flutter",
    prompts: [
      {
        type: "input",
        name: "name",
        message: "¿Cuál es el nombre de tu app? (en minúsculas, ej: my_app)",
      },
      {
        type: "confirm",
        name: "force",
        message: "¿Quieres sobrescribir los archivos existentes?",
        default: false,
      },
    ],
    actions: function (data) {
      const actions = [
        // Core Files
        {
          type: "add",
          path: "lib/core/error/exception.dart",
          templateFile: "plop-templates/core/exception.dart.hbs",
          force: data.force,
        },
        {
          type: "add",
          path: "lib/core/error/failure.dart",
          templateFile: "plop-templates/core/failure.dart.hbs",
          force: data.force,
        },
        {
          type: "add",
          path: "lib/core/usecases/usecase.dart",
          templateFile: "plop-templates/core/usecase.dart.hbs",
          force: data.force,
        },
        {
          type: "add",
          path: "lib/core/constants/loading_status.dart",
          templateFile: "plop-templates/core/loading_status.dart.hbs",
          force: data.force,
        },
        {
          type: "add",
          path: "lib/core/network/network_info/network_info.dart",
          templateFile: "plop-templates/core/network_info.dart.hbs",
          force: data.force,
        },
        {
          type: "add",
          path: "lib/core/network/network_info/network_info_impl.dart",
          templateFile: "plop-templates/core/network_info_impl.dart.hbs",
          force: data.force,
        },
        {
          type: "add",
          path: "lib/core/network/client/client.dart",
          templateFile: "plop-templates/core/client.dart.hbs",
          force: data.force,
        },
        // Main Files
        {
          type: "add",
          path: "lib/main.dart",
          templateFile: "plop-templates/main.dart.hbs",
          force: data.force,
        },
        {
          type: "add",
          path: "lib/app.dart",
          templateFile: "plop-templates/app.dart.hbs",
          force: data.force,
        },
        // DI
        {
          type: "add",
          path: "lib/core/di/injection.dart",
          templateFile: "plop-templates/injection.dart.hbs",
          force: data.force,
        },
        {
          type: "add",
          path: "lib/core/di/navigation_module.dart",
          templateFile: "plop-templates/navigation_module.dart.hbs",
          force: data.force,
        },
        {
          type: "add",
          path: "lib/core/di/network_module.dart",
          templateFile: "plop-templates/core/network_module.dart.hbs",
          force: data.force,
        },
        // Services
        {
          type: "add",
          path: "lib/core/services/navigation/navigation_service.dart",
          templateFile: "plop-templates/navigation_service.dart.hbs",
          force: data.force,
        },
        // Router
        {
          type: "add",
          path: "lib/core/router/app_router.dart",
          templateFile: "plop-templates/app_router.dart.hbs",
          force: data.force,
        },
        // Constants
        {
          type: "add",
          path: "lib/core/constants/app_assets.dart",
          templateFile: "plop-templates/app_assets.dart.hbs",
          force: data.force,
        },
        {
          type: "add",
          path: "lib/core/constants/app_colors.dart",
          templateFile: "plop-templates/app_colors.dart.hbs",
          force: data.force,
        },
        // Theme
        {
          type: "add",
          path: "lib/core/theme/theme.dart",
          templateFile: "plop-templates/theme.dart.hbs",
          force: data.force,
        },
        // VSCode Config
        {
          type: "add",
          path: ".vscode/sessions.json",
          templateFile: "plop-templates/core/sessions.json.hbs",
          force: data.force,
        },
      ];

      return actions;
    },
  });
};
