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
      build_sprites:
        command: "TexturePacker --sheet build/assets/sprites.png --data build/assets/sprites.json --texture-format png --format json --scale 2 --scale-mode fast --disable-rotation assets/sprites"
      build_tiles:
        command: "TexturePacker --sheet build/assets/tiles.png --data build/assets/tiles.json --texture-format png --format json --scale 2 --scale-mode fast --disable-rotation --padding 0 --trim-mode None --algorithm Basic --basic-sort-by Width --basic-order Ascending assets/tiles"

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
        tasks: ["exec:build_sprites"]
      tiles:
        files: ["assets/tiles/**/*"]
        tasks: ["exec:build_tiles"]

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-exec"
  grunt.loadNpmTasks "grunt-newer"

  grunt.registerTask "default", ["coffee", "exec:build_sprites", "exec:build_tiles", "connect", "watch"]
