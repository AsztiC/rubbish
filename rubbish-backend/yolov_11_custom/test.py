import torch
ckpt = torch.load("best.pt", map_location="cpu")
print(ckpt.keys())
