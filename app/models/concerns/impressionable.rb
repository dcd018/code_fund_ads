module Impressionable
  extend ActiveSupport::Concern

  included do
    has_many :impressions
    has_many :daily_summaries, as: :impressionable
  end

  def daily_impressions_counts(start_date = nil, end_date = nil, scoped_by: nil, fresh: false)
    start_date = Date.coerce(start_date)
    end_date = Date.coerce(end_date || start_date)
    key = "#{cache_key}/#{__method__}/#{start_date.cache_key}-#{end_date.cache_key}/#{scoped_by&.cache_key}"
    Rails.cache.fetch key, force: fresh, expires_in: 10.minutes do
      counts_by_date = daily_summaries.between(start_date, end_date).scoped_by(scoped_by)
        .pluck(:displayed_at_date, :impressions_count)
        .each_with_object({}) { |row, memo| memo[row[0]] = row[1] }
      date_range = start_date..end_date
      if date_range.cover?(Date.current)
        counts_by_date[Date.current] = impressions.on(Date.current).scoped_by(scoped_by).count
      end
      date_range.to_a.map { |date| counts_by_date[date] ||= 0 }
    end
  end

  def daily_clicks_counts(start_date = nil, end_date = nil, scoped_by: nil, fresh: false)
    start_date = Date.coerce(start_date)
    end_date = Date.coerce(end_date || start_date)
    key = "#{cache_key}/#{__method__}/#{start_date.cache_key}-#{end_date.cache_key}/#{scoped_by&.cache_key}"
    Rails.cache.fetch key, force: fresh, expires_in: 10.minutes do
      counts_by_date = daily_summaries.between(start_date, end_date).scoped_by(scoped_by)
        .pluck(:displayed_at_date, :clicks_count)
        .each_with_object({}) { |row, memo| memo[row[0]] = row[1] }
      date_range = start_date..end_date
      if date_range.cover?(Date.current)
        counts_by_date[Date.current] = impressions.clicked.on(Date.current).scoped_by(scoped_by).count
      end
      date_range.to_a.map { |date| counts_by_date[date] ||= 0 }
    end
  end

  def impressions_count(start_date = nil, end_date = nil, scoped_by: nil)
    daily_impressions_counts(start_date, end_date, scoped_by: scoped_by).sum
  end

  def clicks_count(start_date = nil, end_date = nil, scoped_by: nil)
    daily_clicks_counts(start_date, end_date, scoped_by: scoped_by).sum
  end

  def click_rate(start_date = nil, end_date = nil, scoped_by: nil)
    icount = impressions_count(start_date, end_date, scoped_by: scoped_by)
    ccount = clicks_count(start_date, end_date, scoped_by: scoped_by)
    icount.zero? ? 0 : (ccount / icount.to_f) * 100
  end

  def gross_revenue(start_date, end_date = nil, scoped_by: nil, fresh: false)
    start_date = Date.coerce(start_date)
    end_date = Date.coerce(end_date || start_date)
    key = "#{cache_key}/#{__method__}/#{start_date.cache_key}-#{end_date.cache_key}/#{scoped_by&.cache_key}"
    cents = Rails.cache.fetch(key, force: fresh, expires_in: 10.minutes) {
      cents_by_date = daily_summaries.between(start_date, end_date).scoped_by(scoped_by)
        .pluck(:displayed_at_date, :gross_revenue_cents)
        .each_with_object({}) { |row, memo| memo[row[0]] = row[1] }
      if (start_date..end_date).cover?(Date.current)
        cents_by_date[Date.current] = impressions.on(Date.current).scoped_by(scoped_by).sum(:estimated_gross_revenue_fractional_cents)
      end
      cents_by_date.values.sum
    }
    Money.new cents, "USD"
  end

  def property_revenue(start_date, end_date = nil, scoped_by: nil, fresh: false)
    start_date = Date.coerce(start_date)
    end_date = Date.coerce(end_date || start_date)
    key = "#{cache_key}/#{__method__}/#{start_date.cache_key}-#{end_date.cache_key}/#{scoped_by&.cache_key}"
    cents = Rails.cache.fetch(key, force: fresh, expires_in: 10.minutes) {
      cents_by_date = daily_summaries.between(start_date, end_date).scoped_by(scoped_by)
        .pluck(:displayed_at_date, :property_revenue_cents)
        .each_with_object({}) { |row, memo| memo[row[0]] = row[1] }
      if (start_date..end_date).cover?(Date.current)
        cents_by_date[Date.current] = impressions.on(Date.current).scoped_by(scoped_by).sum(:estimated_property_revenue_fractional_cents)
      end
      cents_by_date.values.sum
    }.to_i
    Money.new cents, "USD"
  end

  def house_revenue(start_date, end_date = nil, scoped_by: nil, fresh: false)
    start_date = Date.coerce(start_date)
    end_date = Date.coerce(end_date || start_date)
    key = "#{cache_key}/#{__method__}/#{start_date.cache_key}-#{end_date.cache_key}/#{scoped_by&.cache_key}"
    cents = Rails.cache.fetch(key, force: fresh, expires_in: 10.minutes) {
      cents_by_date = daily_summaries.between(start_date, end_date).scoped_by(scoped_by)
        .pluck(:displayed_at_date, :house_revenue_cents)
        .each_with_object({}) { |row, memo| memo[row[0]] = row[1] }
      if (start_date..end_date).cover?(Date.current)
        cents_by_date[Date.current] = impressions.on(Date.current).scoped_by(scoped_by).sum(:estimated_house_revenue_fractional_cents)
      end
      cents_by_date.values.sum
    }.to_i
    Money.new cents, "USD"
  end

  def operational?
    daily_summaries.scoped_by(nil).sum(:impressions_count) > 100
  end
end
