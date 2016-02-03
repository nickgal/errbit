class NoticesController < ApplicationController
  class ParamsError < StandardError; end

  skip_before_action :authenticate_user!, only: :create
  skip_before_action :verify_authenticity_token, only: :create

  rescue_from ParamsError, with: :bad_params

  expose(:app_scope) do
    params[:app_id] ? App.where(_id: params[:app_id]) : App.all
  end

  expose(:app) do
    AppDecorator.new app_scope.find(params[:app_id])
  end

  expose(:problem) do
    ProblemDecorator.new app.problems.find(params[:problem_id])
  end


  def index
    @notices = problem.object.notices.reverse_ordered.
      page(params[:page]).per(50)
  end

  def create
    # params[:data] if the notice came from a GET request, raw_post if it came via POST
    report = ErrorReport.new(notice_params)

    if report.valid?
      if report.should_keep?
        report.generate_notice!
        api_xml = report.notice.to_xml(only: false, methods: [:id]) do |xml|
          xml.url locate_url(report.notice.id, host: Errbit::Config.host)
        end
        render xml: api_xml
      else
        render text: "Notice for old app version ignored"
      end
    else
      render text: "Your API key is unknown", status: 422
    end
  rescue Nokogiri::XML::SyntaxError
    render text: 'The provided XML was not well-formed', status: 422
  end

  # Redirects a notice to the problem page. Useful when using User Information at Airbrake gem.
  def locate
    problem = Notice.find(params[:id]).problem
    redirect_to app_problem_path(problem.app, problem)
  end

private

  def notice_params
    return @notice_params if @notice_params
    @notice_params = params[:data] || request.raw_post
    if @notice_params.blank?
      fail ParamsError, 'Need a data params in GET or raw post data'
    end
    @notice_params
  end

  def bad_params(exception)
    render text: exception.message, status: :bad_request
  end
end
