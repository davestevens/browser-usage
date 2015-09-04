gulp = require("gulp")
gutil = require("gulp-util")
jade = require("gulp-jade")
sass = require("gulp-sass")
coffeeify = require("gulp-coffeeify")
del = require("del")
run_sequence = require("gulp-run-sequence")
zip = require("gulp-zip")

log_error = (error) ->
  gutil.log(gutil.colors.red(error.toString()))
  @emit("end")

options = require("./config.json")
config = options.development

# Compile .jade files to .html files
gulp.task("html", ->
  gulp.src("src/jade/**/[^_]*.jade")
    .pipe(
      jade(config.jade).on("error", log_error)
    )
    .pipe(gulp.dest("web/"))
)

# Compile .scss files to .css files
gulp.task("styles", ->
  gulp.src("src/sass/**/[^_]*.scss")
    .pipe(
      sass(config.sass).on("error", log_error)
    )
    .pipe(gulp.dest("web/css/"))
)

# Compile .coffee files to .js files
gulp.task("scripts", ->
  gulp.src("src/coffee/**/*.coffee")
    .pipe(
      coffeeify(config.coffeeify).on("error", log_error)
    )
    .pipe(gulp.dest("web/js"))
)

# Copy any font files
gulp.task("copy:fonts", ->
  gulp.src("src/fonts/**/*")
    .pipe(gulp.dest("web/fonts/"))
)
# Copy any image files
gulp.task("copy:images", ->
  gulp.src("src/images/**/*")
    .pipe(gulp.dest("web/images/"))
)

gulp.task("watch", ->
  gulp.watch("src/jade/**/*.jade", ["html"])
  gulp.watch("src/sass/**/*.scss", ["styles"])
  gulp.watch("src/coffee/**/*.coffee", ["scripts"])
  gulp.watch("src/fonts/**/*", ["copy:fonts"])
  gulp.watch("src/images/**/*", ["copy:images"])
)

gulp.task("clear:web", ->
  del("web/*")
)

gulp.task("package", ->
  gulp.src("web/**/*", base: ".")
    .pipe(zip("export.zip"))
    .pipe(gulp.dest("."))
)

gulp.task("development", -> config = options.development)
gulp.task("production", -> config = options.production)

gulp.task("build", [
  "production",
  "html",
  "styles",
  "scripts",
  "copy:fonts",
  "copy:images"
])
gulp.task("export", run_sequence(
    "production",
    "clear:web",
    "build"
    "package"
  )
)
gulp.task("default", ["development", "build", "watch"])
