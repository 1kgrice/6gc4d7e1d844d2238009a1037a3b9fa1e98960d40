class ModulesController < ApplicationController
  def landing
    render "modules/landing", layout: "landing"
  end

  def discover
    render "modules/discover", layout: "discover"
  end

  def creator
    render "modules/creator", layout: "creator"
  end
end
