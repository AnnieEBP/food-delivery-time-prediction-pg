## 1. Model Failure: Your model underestimates delivery time on rainy days. Do you fix the model, the data, or the business expectations?
To address this problem, I would start by examining the data and modifying the model. First, I would include precipitation details so that the model can accurately learn about rain-related delays. Next, I would refine the current model through feature engineering, with a specific focus on rain intensity and distance. I would also consider retraining the model with a specialized submodel designed for rainy conditions and retuning it as needed. If these adjustments do not yield satisfactory results, I would consider selecting a different model that is better suited for handling extreme values. Finally, I would align operational expectations by implementing dynamic delivery buffers according to rain severity and effectively communicating the risks of weather-related delays to customers.

## 2.Transferability: The model performs well in Mumbai. It’s now being deployed in São Paulo. How do you ensure generalization?
First, I would compare the distribution of variables between the two countries. Are they behaving the same? If significant changes are identified, I would be aware that modifications are expected. Second, I would take a considerable sample set to reevaluate the model's performance. If the conditions in São Paulo are significantly distinct from those in Mumbai, I would train a model with only Brazil data. A good practice would be to cross-validate by city to measure actual transfer error. For example, the training set is from Mumbai, but the validation is in São Paulo. Next, I would monitor the model in production using an alarm system that triggers when a threshold in error (MAE, MSE, RMSE) is reached.
Communication is also an important component when transferring a model to a new place. I would approach that by:
- Stakeholder Alignment: kickoff briefing; training session
- Operational Document: a concise document explaining the model and its limitations
- Feedback: recurrent feedback from teams

## 3. GenAI Disclosure: Generative AI tools are a great resource that can facilitate development, what parts of this project did you use GenAI tools for? How did you validate or modify their output?
I leveraged on GenAI for support in various phases of the project. I modified the code specifically to create box plots for the quantitative variables and the residuals visualization. I also used it to decide which parameter fitting method to select, as well as specific details of the Random Forest algorithm. It helped me recall concepts I had forgotten from my master's degree. The answers were compared with my class notes. Also, GenAI helped me give my .md reports a clean structure and format. Ultimately, GenAI assisted me in answering the last question in this section. I recognize the need to gain hands-on experience in transferring models to production environments but I'm a fast learner and self-taught.

# 4. Your Signature Insight: What's one non-obvious insight or decision you're proud of from this project?
- I'm pleased to have discovered that a linear model is the best fit for the dataset provided, which adheres to the principle of parsimony. The Law of Parsimony, also known as Occam's Razor, suggests that the simplest explanation is often the best one.
- Although the five outliers in the target variable (delivery time) were evident, there were less obvious ones that needed to be removed to achieve higher model performance. By being more strict, the models achieved greater performance, maintaining 96.5% of the observations.
- To perform well only 4 predictors were necessary (`Distance_km`, `Preparation_Time_min`, `Courier_Experience_yrs`, and `Traffic_Level_ord`)

# 5. Going to Production: How would you deploy your model to production? What other components would you need to include/develop in your codebase? Please be as detailed each step of the process, and feel free to showcase some of these components in the codebase.
1. Model Training and Serialization: Use the provided dataset to train the model, then save it using joblib or pickle so it can be loaded into production systems. 
2. Model Inference API:  Create an API that loads the trained model and exposes a /predict endpoint. The API should accept new order data, preprocess it, and return the predicted delivery time.
3. Preprocessing Pipeline: Encapsulate preprocessing in a function or class to enable reuse. 
4. Automated Batch Scoring (Optional step): For bulk predictions, a script is necessary to load the new data, preprocess it, and write predictions to a file or database.
5. Monitoring and Retraining to maintain the system: monitor model performance in production. Schedule retraining as new data arrives.
6. Other essential components:
    - Unit and integration tests
    - Documentation
    - Security