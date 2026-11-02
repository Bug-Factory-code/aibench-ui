import uvicorn
from backend.app.settings import UI_PORT

if __name__ == "__main__":
    uvicorn.run("backend.app.main:app", host="0.0.0.0", port=UI_PORT, log_level="info")
