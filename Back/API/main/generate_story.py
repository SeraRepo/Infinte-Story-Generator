from transformers import pipeline, AutoTokenizer, AutoModelForCausalLM
import torch
import os

device = "cuda:0" if torch.cuda.is_available() else "cpu"
# device = "cpu"
print(device)

env_model = os.environ['MODEL']
print(env_model)
chosen_model = "EleutherAI/gpt-neo-125M" # Default model for dev purpose
if env_model == '125M':
    chosen_model = "EleutherAI/gpt-neo-125M"
if env_model == '1.3B':
    chosen_model = "EleutherAI/gpt-neo-1.3B"
if env_model == '2.7B':
    chosen_model = "EleutherAI/gpt-neo-2.7B"
print(chosen_model)
tokenizer = AutoTokenizer.from_pretrained(chosen_model)
model = AutoModelForCausalLM.from_pretrained(chosen_model).to(device)

def generate_next_tokens(text_input):
    input_ids = tokenizer.encode(text_input, return_tensors="pt").to(device)
    gen_tokens = model.generate(
        input_ids,
        do_sample=True,
        temperature=0.5,
        max_length=300,
    )
    gen_text = tokenizer.batch_decode(gen_tokens)[0]
    return gen_text

def generate_story(params):    
    parameters = ""

    for i in range(0, len(params)):
        parameters +=  params[i] + " "
    
    story = parameters
    
    for i in range(1, 5):
        text_input = parameters
        if i > 1:
            text_input = text_input + story[len(story)-100:len(story)] if len(story)-100 > len(parameters) else text_input + story[len(story)-len(parameters):len(story)]
        generated_text = generate_next_tokens(text_input)
        story += generated_text[len(text_input) : len(generated_text)]

    return story
