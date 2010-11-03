function itemLoadCallbackFunction(carousel, state)
{
    for (var i = carousel.first; i <= carousel.last; i++) {
        if (!carousel.has(i)) {
            // Add the item
            carousel.add(i, "I'm item #" + i);
        }
    }
}