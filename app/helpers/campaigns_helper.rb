module CampaignsHelper
  def creatives_for_select
    Creative.select(:id, :user_id, :name).order(:name).map do |creative|
      [creative.name, creative.id, data: {parent_id: creative.user_id}]
    end
  end

  def campaign_statuses_for_select
    ENUMS::CAMPAIGN_STATUSES.values.map { |val| [val.humanize, val] }
  end

  def campaign_status_color(status)
    ENUMS::CAMPAIGN_STATUS_COLORS[status]
  end

  def campaign_status_html(status)
    case ENUMS::CAMPAIGN_STATUSES[status]
    when "active" then tag.span(class: "fas fa-circle text-success", title: "Active", data: tooltip_expando(placement: "left"))
    when "pending" then tag.span(class: "fas fa-circle text-warning", title: "Pending", data: tooltip_expando(placement: "left"))
    when "archived" then tag.span(class: "fas fa-circle text-muted", title: "Archived", data: tooltip_expando(placement: "left"))
    end
  end

  def countries_with_codes_for_subregion(subregion)
    Country.where(subregion: subregion).map do |country|
      [country.name, country.iso_code]
    end
  end

  def split_winner?(split_experiment, split_alternative)
    return false unless split_experiment && split_alternative
    return false unless split_experiment.winner
    split_alternative.name == split_experiment.winner.name
  end

  def split_loser?(split_experiment, split_alternative)
    return false unless split_experiment && split_alternative
    return false unless split_experiment.winner
    split_alternative.name != split_experiment.winner.name
  end

  def split_experiment_confidence_level(z_score)
    return z_score if z_score.is_a? String

    z = BigDecimal(z_score.to_s).round(3).to_f.abs

    if z >= 2.58
      "99%"
    elsif z >= 1.96
      "95%"
    elsif z >= 1.65
      "90%"
    else
      "Insufficient"
    end
  end
end
