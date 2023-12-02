import torch
from PIL import Image
from torchvision import transforms
from torchvision.models import resnet50
import argparse

parser = argparse.ArgumentParser("simple_example")
parser.add_argument("resnet_path", help="resnet pth path", type=str)
args = parser.parse_args()

model = resnet50()
model.load_state_dict(torch.load(args.resnet_path))
model.eval()

filename = "dog.jpg"
input_image = Image.open(filename)
preprocess = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])
input_tensor = preprocess(input_image)
input_batch = input_tensor.unsqueeze(0) # create a mini-batch as expected by the model
output = model(input_batch)
probabilities = torch.nn.functional.softmax(output[0], dim=0)
# print(probabilities)
with open("imagenet_classes.txt", "r") as f:
    categories = [s.strip() for s in f.readlines()]

# Show top categories per image
top5_prob, top5_catid = torch.topk(probabilities, 5)
for i in range(top5_prob.size(0)):
    print(categories[top5_catid[i]], top5_prob[i].item())