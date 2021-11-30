---
title: "Documentation"
author: "Aleksandra Cvetanovska"
date: "11/29/2021"
output: html_document
---



## Text Prediction

### About

This is a shiny app that shows shows next word predictions, based on the user's current input. There are many different smoothing techniques that can be used. In this app, we use two different algorithms - `Stupid Back-Off` and `Laplace`. Each algorithm calculates the probabilities differently, so it ranks the predicted words differently. To test out the algorithms, enter some text in the input box, and you will see a list of words and their probabilities returned from the algorithm, shown on each tab correspondingly.
 
## Stupid Back-Off Smoothing

The algorithm is described in a paper by Brands et al., 2007: https://aclanthology.org/D07-1090.pdf. 
According to the paper: `Stupid Backoff is inexpensive to calculate in a distributed environment while approaching the quality of Kneser-Ney smoothing for large amounts of data`.

The algorithm discounts lower-level n-grams, by a parameter alpha which is usually set at 0.4 (that is the value we're using in this implementation of the algorithm). The recursion of the algorithm ends with unigrams.

## Laplace Smothing

The Laplace algorithm, also called `add-one` algorithm, works by adding one to all n-grams before calculating their probabilities. With this technique we ensure that we'd never run into a probability of 0, which allows us to avoid accidentally running into division by 0. This algorithm does not perform as well as other smoothing algorithms. Laplace allows for prediction in rare cases.

