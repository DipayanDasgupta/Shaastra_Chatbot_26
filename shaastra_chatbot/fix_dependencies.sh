#!/bin/bash

echo "🚀 Starting Dependency Fixer..."

# 1. Uninstall EVERYTHING related to the conflict
echo "🗑️  Removing conflicting packages..."
pip uninstall -y tensorflow tensorflow-intel protobuf transformers google-auth opentelemetry-api opentelemetry-sdk

# 2. Install PyTorch ecosystem FIRST (The base)
echo "📦 Installing PyTorch and Transformers..."
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
pip install transformers==4.40.0 accelerate bitsandbytes

# 3. Install Protobuf (The Conflict Maker) - Version 3.20.3 is the golden standard for compatibility
echo "📦 Installing Protobuf 3.20.3..."
pip install protobuf==3.20.3

# 4. Install RAG & LangChain dependencies (Without upgrading protobuf)
echo "📦 Installing LangChain & RAG tools..."
# We use --no-deps to prevent it from upgrading protobuf automatically
pip install langchain langchain-community langchain-core langchain-huggingface langchain-chroma

# 5. Install Audio Tools (Parler/Whisper)
echo "📦 Installing Audio tools..."
pip install faster-whisper gTTS pydub python-multipart uvicorn fastapi
pip install git+https://github.com/huggingface/parler-tts.git

# 6. Final cleanup checks
echo "🧹 Cleaning up..."
# Force tensorflow to be absent or cpu-only if absolutely required by some sub-dep
# We try to avoid installing full tensorflow as it brings the protobuf hell.
pip uninstall -y tensorflow

echo "✅ Done! Try running 'python api.py' now."