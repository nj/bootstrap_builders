class BootstrapBuilders::Tabs
  def initialize(args)
    @context = args.fetch(:context)
    @tabs = []
  end

  def tab(*args, &blk)
    tab_args = {}

    tab_args[:label] = args.shift if args.first.is_a?(String)
    tab_args[:container_id] = args.shift if args.first.is_a?(String)
    tab_args.merge!(args.shift) if args.first.is_a?(Hash)

    tab = BootstrapBuilders::Tab.new(tab_args)
    tab.container_html = @context.content_tag(:div, nil, class: ["bb-tab-container"], &blk)
    @tabs << tab
    nil
  end

  def to_html
    container = HtmlGen::Element.new(:div, inden: "  ", classes: ["bb-tabs-container"])
    ul = container.add_ele(:ul, classes: ["nav", "nav-tabs"])

    @tabs.each do |tab|
      li = ul.add_ele(:li)
      li.add_ele(:a, str: tab.label, attr: {href: "##{tab.container_id}"}, data: {toggle: "tab"})
      li.classes << "active" if tab.active?
    end

    tabs_content = container.add_ele(:div, classes: ["tab-content"])

    @tabs.each do |tab|
      tab_content = tabs_content.add_ele(:div, classes: ["tab-pane"], attr: {id: tab.container_id})
      tab_content.add_ele(:h3, str: tab.label)
      tab_content.add_html(tab.container_html)
      tab_content.classes << "active" if tab.active?
    end

    container.html
  end
end
