#!/usr/bin/env python3
"""
Wrapper script to run the Streamlit dashboard
"""
import sys
import os
from pathlib import Path


def main():
    """Run the Streamlit dashboard"""
    # Get the path to app.py relative to this script
    dashboard_dir = Path(__file__).parent
    app_path = dashboard_dir / "app.py"
    
    # Import streamlit CLI and run it
    from streamlit.web import cli as stcli
    
    # Set up the arguments for streamlit run
    sys.argv = [
        "streamlit",
        "run",
        str(app_path),
        "--server.port=8501",
        "--server.address=localhost",
    ]
    
    sys.exit(stcli.main())


if __name__ == "__main__":
    main()

