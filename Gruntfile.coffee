module.exports = (grunt) ->
  grunt.initConfig

    coffee:
      dev:
        expand: true
        cwd: "src"
        src: "**/*.coffee"
        dest: "build/js/game"
        ext: ".js"

    exec:
      build_assets:
        command: "TexturePacker --sheet build/assets/sprites.png --data build/assets/sprites.json --texture-format png --format json assets/sprites"

    connect:
      site:
        options:
          port: 8080
          base: 'build'

    watch:
      dev:
        files: ["src/**/*.coffee"]
        tasks: ["newer:coffee"]
      assets:
        files: ["assets/sprites/**/*"]
        tasks: ["exec:build_assets"]

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-exec"
  grunt.loadNpmTasks "grunt-newer"

  grunt.registerTask "default", ["coffee", "exec:build_assets", "connect", "watch"]
