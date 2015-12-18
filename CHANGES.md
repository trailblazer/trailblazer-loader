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