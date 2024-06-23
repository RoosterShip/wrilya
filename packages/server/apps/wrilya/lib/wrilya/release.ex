defmodule Wrilya.Release do
  @moduledoc """
  This module is used to manage a release launch.  When a pod first starts
  up it might need to do a database migration/rollback/etc.  This module
  is where some custom commands are defined to be executed by the calling
  binary.

  Please review the release management documentation
  """
  use Utils.Release, app: :wrilya
end
