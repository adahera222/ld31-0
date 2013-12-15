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
        command: "TexturePacker --sheet build/assets/sprites.png --data build/assets/sprites.json --texture-format png --format json --scale 2 --scale-mode fast --disable-rotation --trim-mode None assets/sprites"
      build_fonts:
        command: "TexturePacker --sheet build/assets/fonts.png --data build/assets/fonts.json --texture-format png --format json --scale-mode fast --disable-rotation --padding 0 --trim-mode None --algorithm Basic --basic-sort-by Width --basic-order Ascending assets/fonts"

    connect:
      site:
        options:
          port: 8080
          base: 'build'

    watch:
      dev:
        files: ["src/**/*.coffee"]
        tasks: ["coffee", "notify:compiled"]
      assets:
        files: ["assets/sprites/**/*"]
        tasks: ["exec:build_sprites"]
      fonts:
        files: ["assets/fonts/**/*"]
        tasks: ["exec:build_fonts"]

    notify:
      compiled:
        options:
          title: "Compiled"
          message: "All assets have been compiled."

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-exec"
  grunt.loadNpmTasks "grunt-newer"
  grunt.loadNpmTasks "grunt-notify"

  grunt.registerTask "default", ["coffee", "exec:build_sprites", "exec:build_fonts", "connect", "watch"]
