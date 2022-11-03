# A literal sandbox made with scenic

This is a toy project to ~~play~~ experiment with Scenic, a 2D UI framework for Elixir.
It's used to see how far it can go for games, how far it can be stretched before it breaks.
It contains several scenes that try different things:

## SingleGrainScene
This scene draw X sandgrains that fall down. Every grain is controlled by a single component.
This works, but on my laptop I see it breaking down when you go into the hundreds of grains, mainly due to a (very) high memory usage.

## MultipleGrainScene
This scene tries to improve the performance by having all grains simulated by a single component.
> Todo, work in progress
