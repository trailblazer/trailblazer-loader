# 0.1.2

* Introduce `Loader#default_circuit` to override specific positions in the loading process. This is a bit hacky and will be
refined in v1.0.

# 0.1.1

* The loading order on OSX is now identical to Linux. Thanks to @pnikolov.

# 0.1.0

* New option `:root` to allow using loader for sources other than the current directory, e.g. for gems or Rails engines.
* `:concept_root` is now prefixed with `:root`.
* Use `File::SEPARATOR` for filename operations.
* Don't use a regexp anymore to find concept files, but `Loader#concept_dirs` which includes plural names.
* Allow irregular directory names such as `policies`.
* Allow prepending to the pipeline using `:prepend`. Note that this is a temporary API and will be removed.

# 0.0.9

* Bug fix :cough:.

# 0.0.8

* Add `debug: true` option instead of relying on env vars.

# 0.0.7

* Fix a ordering bug. Thanks @Hermanverschooten.

# 0.0.6

* Allow injection of additional files in `Loader::ConceptFiles` from earlier functions.

# 0.0.5

* Remove `representable` dependency. This is a temporary fix until we have a pipelining gem.

# 0.0.4

* Fix loading for explicit layouts.

# 0.0.3

* Bump to Representable 2.4.0 as we use `Pipeline::Collect`. This doesn't mean this dependency will last forever. We might switch to `call_sheet` for pipelines.

# 0.0.2

* Internally, use `Representable::Pipeline` to model the loading steps. This allows gems like `trailblazer-rails` to plug in additional loading steps.

# 0.0.1

* Obviously, the first version ever. This implements the "lexical-width" strategy, only.
