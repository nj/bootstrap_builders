module BootstrapBuilders::ApplicationHelper
  def bb_attribute_rows(model, attributes)
    BootstrapBuilders::AttributeRows.new(model: model, attributes: attributes, context: self).html
  end

  def bb_panel(*opts, &blk)
    title = opts.shift unless opts.first.is_a?(Hash)
    width = opts.shift unless opts.first.is_a?(Hash)

    if opts.length == 1 && opts.first.is_a?(Hash)
      args = opts.first
      title = args.fetch(:title) if args.key?(:title)
      width = args[:width] if args.key?(:width)
      right = args[:right] if args.key?(:right)
    else
      args = {}
    end

    BootstrapBuilders::Panel.new(args.merge(title: title, width: width, right: right, block: blk, context: self)).html
  end

  def bb_btn(*args)
    args = BootstrapBuilders::Button.parse_url_args(args)
    args[:context] = self
    button = BootstrapBuilders::Button.new(args)
    button.classes.add("bb-btn")
    button.html
  end

  def bb_edit_btn(*args)
    args = BootstrapBuilders::Button.parse_url_args(args)
    args[:label] = t("edit") unless args.key?(:label)
    args[:title] ||= t("edit") if args[:mini]
    args[:url] = [:edit, args.fetch(:url)] if args[:url] && !args[:url].is_a?(Array) && BootstrapBuilders::IsAChecker.is_a?(args[:url], "ActiveRecord::Base")

    button = BootstrapBuilders::Button.new(args.merge(icon: "wrench", context: self, can_type: :edit))
    button.classes.add(["bb-btn", "bb-btn-edit"])
    button.classes.add("bb-btn-edit-#{button.can_model_class.name.tableize.singularize}") if button.can_model_class
    button.classes.add("bb-btn-edit-#{button.can_model_class.name.tableize.singularize}-#{button.can_model.id}") if button.can_model
    button.html
  end

  def bb_destroy_btn(*args)
    args = BootstrapBuilders::Button.parse_url_args(args)
    args[:label] = t("delete") unless args.key?(:label)
    args[:title] ||= t("delete") if args[:mini]

    args[:data] ||= {}
    args[:data][:confirm] ||= t("are_you_sure")

    button = BootstrapBuilders::Button.new(args.merge(icon: "remove", context: self, can_type: :destroy, method: :delete))
    button.classes.remove(["btn-default"])
    button.classes.add(["btn-danger", "bb-btn", "bb-btn-destroy"])
    button.classes.add("bb-btn-destroy-#{button.can_model_class.name.tableize.singularize}") if button.can_model_class
    button.classes.add("bb-btn-destroy-#{button.can_model_class.name.tableize.singularize}-#{button.can_model.id}") if button.can_model
    button.html
  end

  def bb_new_btn(*args)
    args = BootstrapBuilders::Button.parse_url_args(args)
    args[:label] = t("add_new") unless args.key?(:label)
    args[:title] ||= t("new") if args[:mini]

    button = BootstrapBuilders::Button.new(args.merge(icon: "pencil", context: self, can_type: :new))
    button.classes.add(["bb-btn", "bb-btn-new"])
    button.classes.add("bb-btn-new-#{button.can_model_class.name.tableize.singularize}") if button.can_model_class
    button.html
  end

  def bb_index_btn(*args)
    args = BootstrapBuilders::Button.parse_url_args(args)
    args[:title] ||= t("index") if args[:mini]

    button = BootstrapBuilders::Button.new(args.merge(icon: "table", context: self, can_type: :index))

    if button.label.to_s.strip.empty?
      if button.can_model_class
        button.label = button.can_model_class.model_name.human(count: 2)
      else
        button.label = t("index")
      end
    end

    button.classes.add(["bb-btn", "bb-btn-index"])
    button.classes.add("bb-btn-index-#{button.can_model_class.name.tableize}") if button.can_model_class
    button.html
  end

  def bb_show_btn(*args)
    args = BootstrapBuilders::Button.parse_url_args(args)
    args[:label] = t("show") unless args.key?(:label)
    args[:title] ||= t("show") if args[:mini]

    button = BootstrapBuilders::Button.new(args.merge(icon: "square-o", context: self, can_type: :show))
    button.classes.add(["bb-btn", "bb-btn-show"])
    button.classes.add("bb-btn-show-#{button.can_model_class.name.tableize.singularize}") if button.can_model_class
    button.classes.add("bb-btn-show-#{button.can_model_class.name.tableize.singularize}-#{button.can_model.id}") if button.can_model
    button.html
  end

  def bb_flash(args = {})
    flash = BootstrapBuilders::Flash.new(args.merge(context: self))
    flash.html
  end

  def bb_table(args = {}, &blk)
    table = BootstrapBuilders::Table.new(args.merge(context: self, blk: blk))
    table.html
  end

  def bb_tabs(args = {})
    tabs = BootstrapBuilders::Tabs.new(args.merge(context: self))
    yield tabs
    tabs.to_html
  end
end
