## Implementation of AdaBoost classifier

### Description

This is an implementation of the AdaBoost algorithm for a two-class classification problem. The algorithm sequentially applies a weak classification to modified versions of the data. By increasing the weights of the missclassified observations, each weak learner focuses on the error of the previous one. The predictions are aggregated through a weighted majority vote. 

### Methods
Adaboost algorithm: <br />
<img src="https://github.com/mnitin3/AdaBoost/blob/master/images/adaboost_algo.png" width="500"> <br />

### Dataset
https://archive.ics.uci.edu/ml/datasets/Adult

### Training Results
<img src="https://github.com/mnitin3/AdaBoost/blob/master/images/adaboostResults.png" width="500"> <br />

### References
- Trevor Hastie, Robert Tibshirani, Jerome Friedman - *The Elements of Statistical Learning*
