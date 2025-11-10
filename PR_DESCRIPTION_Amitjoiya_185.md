### Overview
This PR adds automatic logging of up to five annotated images before training starts.  
It helps verify that image–annotation alignment is correct.

### Motivation
Users often make mistakes in dataset setup.  
By logging a few samples automatically, this feature helps confirm that annotations and images match correctly.

### Implementation
- Added logic in `on_train_start()`.
- Randomly selects up to 5 annotated samples from `non_empty_train_annotations`.
- Uses `visualize.plot_annotations()` to generate visualizations.
- Logs images using the active experiment logger (Comet, WandB, or TensorBoard).
- Code is simple and consistent with existing style.

### Testing
- Verified locally with different datasets.
- Confirmed compatibility with all supported loggers.

### Notes
Only relevant code changes are included.  
No formatting or unrelated files modified.
