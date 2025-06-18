{
  home.file.".ipython/profile_default/startup/start.ipy".text = ''
    from pathlib import Path
    from datetime import datetime, date, timedelta, timezone, UTC
    from textwrap import dedent
    from os import environ, getenv

    %load_ext autoreload
    %autoreload 2
  '';
}
