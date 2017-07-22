SimpleNavigation::Configuration.run do |navigation|
  initial_logger = ActiveRecord::Base.logger
  ActiveRecord::Base.logger = nil
  # who is the logged in user
  # logged in users role
  l_role_id = current_user.get_role_id()
  # confugurations -start
  navigation.auto_highlight = false
  # confugurations -end
  navigation.items do |primary|
    # if current_user.system_support_role?|| current_user.system_admin_role?
      primary.dom_id = 'list-nav'
      primary.item(:search, 'Search', new_focus_client_search_path)

             @primary_menu_list = RubyElement.get_primary(l_role_id,6350)

              @primary_menu_list.each do |primary_list| #level 1 menu
                # primary.item(:pre_screening, primary_list.element_title, primary_list.element_name) do |pre_screening_main|
                if  primary_list.element_help_page.blank? #123
                           primary.item(:pre_screening, primary_list.element_title, "#{format_url_with_paramaters(primary_list.element_name)}") do |pre_screening_main|

                          pre_screening_main.dom_id = 'list-nav-secondary'
                          @secondary_menu_list = RubyElement.get_secondary(primary_list.id,l_role_id,6350)
                          @secondary_menu_list.each do |secondary_list| # level 2 menu
                            if secondary_list.element_help_page.blank?
                               pre_screening_main.item :pre_screening, secondary_list.element_title, "#{format_url_with_paramaters(secondary_list.element_name)}" do |pre_scr_household|
                                 pre_scr_household.dom_id = 'list-subnav'
                                 @sub_nav_menu_list = RubyElement.get_secondary(secondary_list.id,l_role_id,6350)
                                 @sub_nav_menu_list.each do |sub_nav_list| # level 3 menu

                                  if sub_nav_list.element_help_page.blank?
                                    if sub_nav_list.element_microhelp == "action_plans"
                                      if session[:BRP].present?
                                        if sub_nav_list.element_title == "Barrier Reduction Plan"
                                          pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                        else
                                          pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}"
                                        end
                                      else
                                        if sub_nav_list.element_title == "Employment Plan"
                                          pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                        else
                                          pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}"
                                        end
                                      end
                                    else
                                      pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                    end
                                    # pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                  else
                                    if (sub_nav_list.element_help_page == 'CL' && session[:CLIENT_ID].present?) ||
                                      (sub_nav_list.element_help_page == 'PU' && session[:PROGRAM_UNIT_ID].present?) ||
                                      (sub_nav_list.element_help_page == 'PR' && session[:PROVIDER_ID].present?) ||
                                      (sub_nav_list.element_help_page == 'AP' && session[:APPLICATION_ID].present?) ||
                                      (sub_nav_list.element_help_page == 'EP' && session[:EMPLOYER_ID].present?) ||
                                      (sub_nav_list.element_help_page == 'ED' && session[:SCHOOLS_ID].present?) ||
                                      (sub_nav_list.element_help_page == 'AS' && session[:CLIENT_ASSESSMENT_ID].present?)
                                      # (sub_nav_list.element_help_page == 'AS')

                                      if sub_nav_list.element_microhelp == "action_plans"
                                        if session[:BRP].present?
                                          if sub_nav_list.element_title == "Barrier Reduction Plan"
                                            pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                          else
                                            pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}"
                                          end
                                        else
                                          if sub_nav_list.element_title == "Employment Plan"
                                            pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                          else
                                            pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}"
                                          end
                                        end
                                      else
                                        pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                      end
                                    end
                                  end
                                 end #do |sub_nav_list|
                               end #do |pre_scr_household|
                            else
                              if (secondary_list.element_help_page == 'CL' && session[:CLIENT_ID].present?) ||
                                        (secondary_list.element_help_page == 'PU' && session[:PROGRAM_UNIT_ID].present?) ||
                                        (secondary_list.element_help_page == 'PR' && session[:PROVIDER_ID].present?) ||
                                        (secondary_list.element_help_page == 'AP' && session[:APPLICATION_ID].present?) ||
                                        (secondary_list.element_help_page == 'EP' && session[:EMPLOYER_ID].present?) ||
                                        (secondary_list.element_help_page == 'ED' && session[:SCHOOLS_ID].present?) ||
                                        (secondary_list.element_help_page == 'AS' && session[:CLIENT_ASSESSMENT_ID].present?)
                                        # (secondary_list.element_help_page == 'AS')

                                          pre_screening_main.item :pre_screening, secondary_list.element_title, "#{format_url_with_paramaters(secondary_list.element_name)}" do |pre_scr_household|
                                           pre_scr_household.dom_id = 'list-subnav'
                                           @sub_nav_menu_list = RubyElement.get_secondary(secondary_list.id,l_role_id,6350)
                                           @sub_nav_menu_list.each do |sub_nav_list|
                                            if sub_nav_list.element_help_page.blank?
                                              if sub_nav_list.element_microhelp == "action_plans"
                                                if session[:BRP].present?
                                                  if sub_nav_list.element_title == "Barrier Reduction Plan"
                                                    pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                                  else
                                                    pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}"
                                                  end
                                                else
                                                  if sub_nav_list.element_title == "Employment Plan"
                                                    pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                                  else
                                                    pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}"
                                                  end
                                                end
                                              else
                                                pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                              end
                                            else
                                               if (sub_nav_list.element_help_page == 'CL' && session[:CLIENT_ID].present?) ||
                                                  (sub_nav_list.element_help_page == 'PU' && session[:PROGRAM_UNIT_ID].present?) ||
                                                  (sub_nav_list.element_help_page == 'PR' && session[:PROVIDER_ID].present?) ||
                                                  (sub_nav_list.element_help_page == 'AP' && session[:APPLICATION_ID].present?) ||
                                                  (sub_nav_list.element_help_page == 'EP' && session[:EMPLOYER_ID].present?) ||
                                                  (sub_nav_list.element_help_page == 'ED' && session[:SCHOOLS_ID].present?) ||
                                                  (sub_nav_list.element_help_page == 'AS' && session[:CLIENT_ASSESSMENT_ID].present?)
                                                  # (sub_nav_list.element_help_page == 'AS')
                                                  if sub_nav_list.element_microhelp == "action_plans"
                                                    if session[:BRP].present?
                                                      if sub_nav_list.element_title == "Barrier Reduction Plan"
                                                        pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                                      else
                                                        pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}"
                                                      end
                                                    else
                                                      if sub_nav_list.element_title == "Employment Plan"
                                                        pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                                      else
                                                        pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}"
                                                      end
                                                    end
                                                  else
                                                    pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                                  end
                                                      # pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})

                                                end
                                            end
                                           end #do |sub_nav_list|
                                         end #do |pre_scr_household|
                              end
                            end
                          end #do |secondary_list|
                        end #do |pre_screening_main|


                else
                      if (primary_list.element_help_page == 'CL' && session[:CLIENT_ID].present?) ||
                                                  (primary_list.element_help_page == 'PU' && session[:PROGRAM_UNIT_ID].present?) ||
                                                  (primary_list.element_help_page == 'PR' && session[:PROVIDER_ID].present?) ||
                                                  (primary_list.element_help_page == 'AP' && session[:APPLICATION_ID].present?) ||
                                                  (primary_list.element_help_page == 'EP' && session[:EMPLOYER_ID].present?) ||
                                                  (primary_list.element_help_page == 'ED' && session[:SCHOOLS_ID].present?) ||
                                                  (primary_list.element_help_page == 'AS' && session[:CLIENT_ASSESSMENT_ID].present?)
                                                  # (primary_list.element_help_page == 'AS')

                        primary.item(:pre_screening, primary_list.element_title, "#{format_url_with_paramaters(primary_list.element_name)}") do |pre_screening_main|

                          pre_screening_main.dom_id = 'list-nav-secondary'
                          @secondary_menu_list = RubyElement.get_secondary(primary_list.id,l_role_id,6350)
                          @secondary_menu_list.each do |secondary_list|
                            if secondary_list.element_help_page.blank?
                               pre_screening_main.item :pre_screening, secondary_list.element_title, "#{format_url_with_paramaters(secondary_list.element_name)}" do |pre_scr_household|
                                 pre_scr_household.dom_id = 'list-subnav'
                                 @sub_nav_menu_list = RubyElement.get_secondary(secondary_list.id,l_role_id,6350)
                                 @sub_nav_menu_list.each do |sub_nav_list|

                                  if sub_nav_list.element_help_page.blank?
                                    if sub_nav_list.element_microhelp == "action_plans"
                                      if session[:BRP].present?
                                        if sub_nav_list.element_title == "Barrier Reduction Plan"
                                          pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                        else
                                          pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}"
                                        end
                                      else
                                        if sub_nav_list.element_title == "Employment Plan"
                                          pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                        else
                                          pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}"
                                        end
                                      end
                                    else
                                      pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                    end

                                    # pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                  else
                                     if (sub_nav_list.element_help_page == 'CL' && session[:CLIENT_ID].present?) ||
                                        (sub_nav_list.element_help_page == 'PU' && session[:PROGRAM_UNIT_ID].present?) ||
                                        (sub_nav_list.element_help_page == 'PR' && session[:PROVIDER_ID].present?) ||
                                        (sub_nav_list.element_help_page == 'AP' && session[:APPLICATION_ID].present?) ||
                                        (sub_nav_list.element_help_page == 'EP' && session[:EMPLOYER_ID].present?) ||
                                        (sub_nav_list.element_help_page == 'ED' && session[:SCHOOLS_ID].present?) ||
                                        (sub_nav_list.element_help_page == 'AS' && session[:CLIENT_ASSESSMENT_ID].present?)
                                        # (sub_nav_list.element_help_page == 'AS')
                                        if sub_nav_list.element_microhelp == "action_plans"
                                          if session[:BRP].present?
                                            if sub_nav_list.element_title == "Barrier Reduction Plan"
                                              pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                            else
                                              pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}"
                                            end
                                          else
                                            if sub_nav_list.element_title == "Employment Plan"
                                              pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                            else
                                              pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}"
                                            end
                                          end
                                        else
                                          pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                        end
                                        # pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                      end
                                  end
                                 end #do |sub_nav_list|
                               end #do |pre_scr_household|
                            else
                              if (secondary_list.element_help_page == 'CL' && session[:CLIENT_ID].present?) ||
                                        (secondary_list.element_help_page == 'PU' && session[:PROGRAM_UNIT_ID].present?) ||
                                        (secondary_list.element_help_page == 'PR' && session[:PROVIDER_ID].present?) ||
                                        (secondary_list.element_help_page == 'AP' && session[:APPLICATION_ID].present?) ||
                                        (secondary_list.element_help_page == 'EP' && session[:EMPLOYER_ID].present?) ||
                                        (secondary_list.element_help_page == 'ED' && session[:SCHOOLS_ID].present?) ||
                                        (secondary_list.element_help_page == 'AS' && session[:CLIENT_ASSESSMENT_ID].present?)
                                        # (secondary_list.element_help_page == 'AS')

                                          pre_screening_main.item :pre_screening, secondary_list.element_title, "#{format_url_with_paramaters(secondary_list.element_name)}" do |pre_scr_household|
                                           pre_scr_household.dom_id = 'list-subnav'
                                           @sub_nav_menu_list = RubyElement.get_secondary(secondary_list.id,l_role_id,6350)
                                           @sub_nav_menu_list.each do |sub_nav_list|
                                            if sub_nav_list.element_help_page.blank?

                                              if sub_nav_list.element_microhelp == "action_plans"
                                                if session[:BRP].present?
                                                  if sub_nav_list.element_title == "Barrier Reduction Plan"
                                                    pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                                  else
                                                    pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}"
                                                  end
                                                else
                                                  if sub_nav_list.element_title == "Employment Plan"
                                                    pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                                  else
                                                    pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}"
                                                  end
                                                end
                                              else
                                                pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                              end

                                              # pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                            else
                                               if (sub_nav_list.element_help_page == 'CL' && session[:CLIENT_ID].present?) ||
                                                  (sub_nav_list.element_help_page == 'PU' && session[:PROGRAM_UNIT_ID].present?) ||
                                                  (sub_nav_list.element_help_page == 'PR' && session[:PROVIDER_ID].present?) ||
                                                  (sub_nav_list.element_help_page == 'AP' && session[:APPLICATION_ID].present?) ||
                                                  (sub_nav_list.element_help_page == 'EP' && session[:EMPLOYER_ID].present?) ||
                                                  (sub_nav_list.element_help_page == 'ED' && session[:SCHOOLS_ID].present?) ||
                                                  (sub_nav_list.element_help_page == 'AS' && session[:CLIENT_ASSESSMENT_ID].present?)
                                                  # (sub_nav_list.element_help_page == 'AS')

                                                  if sub_nav_list.element_microhelp == "action_plans"
                                                    if session[:BRP].present?
                                                      if sub_nav_list.element_title == "Barrier Reduction Plan"
                                                        pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                                      else
                                                        pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}"
                                                      end
                                                    else
                                                      if sub_nav_list.element_title == "Employment Plan"
                                                        pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                                      else
                                                        pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}"
                                                      end
                                                    end
                                                  else
                                                    pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})
                                                  end

                                                    # pre_scr_household.item :pre_screening, sub_nav_list.element_title,"#{format_url_with_paramaters(sub_nav_list.element_name)}",highlights_on: %r(/#{sub_nav_list.element_microhelp})

                                                end
                                            end
                                           end #do |sub_nav_list|
                                         end #do |pre_scr_household|
                              end
                            end
                          end #do |secondary_list|
                        end #do |pre_screening_main|
                      end #else part
                   end # #123 part
              end  # @primary_menu_list.each do |primary_list|
  end # end of navigation.items do |primary| - line 5
  ActiveRecord::Base.logger = initial_logger
end# SimpleNavigation::Configuration.run do |navigation| - line 1
















