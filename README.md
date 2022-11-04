# A literal sandbox made with scenic

This is a toy project to ~~play~~ experiment with Scenic, a 2D UI framework for Elixir.
It's used to see how far it can go for games, how far it can be stretched before it breaks.
It contains several scenes that try different things:

## SingleGrainScene
This scene draw X sandgrains that fall down. Every grain is controlled by a single component.
This works, but on my laptop I see it breaking down when you go into the hundreds of grains, mainly due to a (very) high memory usage.
This shows that spawning hundreds of Scenic components is probably a bad idea.

## MultipleGrainScene
This scene tries to improve the performance by having all grains simulated by a single component.
This works better than the SingleGrainScene. It's possible (on my laptop) to scale this to 1000 grains, although it will start being slower at that point.
Memory consumption is really low, so that problem is tacked. But that single component that has to calculate and spawn 1000 grains is taking too long for the duration of 1 tick.

## MultipleMultipleGrainScene
If one component with 1000 of grains is taking too long to simulate all grains in 20ms, how about if we use 10 components with 100 grains? of 100 components of 100 grains?
The MultipleMultipleGrainScene shows that running 1000 grains this way is definitely faster than in the MultipleGrainScene, but running 5000 grains is too much again.
The problem lies with adding the rectangles to the scene every frame, which just takes a lot of time. Doing it in parallel helps, but there's an upper limit of how much you can draw in a certain (small) time.

