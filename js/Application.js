// Generated by CoffeeScript 1.10.0
(function() {
  window.Application = function() {
    var aD, aM;
    aD = {
      server: 'http://try-catch-vassiliy-pimkin.herokuapp.com/',
      verbs: {
        create: 'POST',
        update: 'PUT',
        destroy: 'DELETE'
      }
    };
    aM = {
      csonify: function(obj, indent) {
        var key, prefix, value;
        indent = indent ? indent + 1 : 1;
        prefix = Array(indent).join('  ');
        if (typeof obj === 'string') {
          return ' "' + obj + '"';
        }
        if (typeof obj !== 'object') {
          return ' ' + obj;
        }
        if (Array.isArray(obj)) {
          return ' [' + ((function() {
            var i, len, results;
            results = [];
            for (i = 0, len = obj.length; i < len; i++) {
              value = obj[i];
              results.push(aM.csonify(value));
            }
            return results;
          })()).join(',') + ' ]';
        }
        return ((function() {
          var results;
          results = [];
          for (key in obj) {
            value = obj[key];
            results.push('\n' + prefix + '"' + key + '":' + aM.csonify(value, indent));
          }
          return results;
        })()).join('');
      },
      render_login_info: function() {
        var css, role;
        if (aD.username != null) {
          role = aD.admin ? 'admin' : 'user';
          css = aD.admin ? 'btn-success' : 'btn-info';
          return $('#login-info-container').loadTemplate($('#logout'), {
            username: aD.username,
            role: role,
            "class": css
          });
        } else {
          return $('#login-info-container').loadTemplate($('#login'));
        }
      },
      logout: function() {
        delete aD.username;
        delete aD.password;
        delete aD.admin;
        delete aD.user_id;
        aM.render_login_info();
        return aM.load_topics_list();
      },
      data_check_username: function() {
        return aM.check_username($(this).val());
      },
      check_username: function(username) {
        return $.getJSON(aD.server + "users.json", {
          username: username
        }).done(function(data) {
          if (data.length === 0) {
            $('nav [data-submit="users:update"]').addClass('disabled');
            return $('nav [data-form]').removeAttr('value');
          } else {
            aD.username = username;
            aD.admin = data[0].admin;
            aD.user_id = data[0].id;
            $('nav [data-submit="users:update"]').removeClass('disabled');
            return $('nav [data-form]').attr('value', data[0].id);
          }
        });
      },
      enable_update: function() {
        var form, valid;
        form = $(this).parents('[data-form]');
        valid = true;
        $(form).find('input, textarea').each(function() {
          if ($(this).val() === '') {
            return valid = false;
          }
        });
        if (valid) {
          form.find('[data-submit*="update"]').removeClass('disabled');
          return form.find('[data-submit*="create"]').removeClass('disabled');
        } else {
          form.find('[data-submit*="update"]').addClass('disabled');
          return form.find('[data-submit*="create"]').addClass('disabled');
        }
      },
      render_done_state: function(model, verb, button, data) {
        var form;
        form = $(button).parents('[data-form]');
        switch (verb) {
          case 'PUT':
            return form.find('[data-submit*="update"]').addClass('disabled');
          case 'DELETE':
            return form.remove();
          default:
            return console.log('created');
        }
      },
      load_topics_list: function() {
        return $.getJSON(aD.server + "topics.json").done(function(data) {
          return $('#work-space').loadTemplate($('#topics'), {}, {
            afterInsert: function() {
              var i, len, template, topic;
              for (i = 0, len = data.length; i < len; i++) {
                topic = data[i];
                template = 'topic';
                if (aD.user_id != null) {
                  if (aD.admin) {
                    template = 'topic-editable';
                  }
                  if (aD.user_id === topic.user_id) {
                    template = 'topic-editable';
                  }
                }
                $('#topics-list').loadTemplate($('#' + template), topic, {
                  append: true
                });
              }
              if (aD.user_id != null) {
                return $('#topics-list').loadTemplate($('#new-topic'), {}, {
                  append: true
                });
              }
            }
          });
        });
      },
      common_submit: function() {
        var controller, form, id, login, model, params, password, route_data, self, type, url, username;
        console.log(aD.username);
        console.log(aD.password);
        self = this;
        if (!$(self).hasClass('disabled')) {
          route_data = $(self).data('submit').split(':');
          controller = route_data[0];
          type = aD.verbs[route_data[1]];
          form = $(self).parents('[data-form]');
          id = type === 'POST' ? '' : '/' + $(form).attr('value');
          url = aD.server + controller + id + '.json';
          if (type !== 'DELETE') {
            params = {};
            model = controller.slice(0, -1);
            params[model] = {};
            form.find('input, textarea').each(function() {
              return params[model][$(this).data('field')] = $(this).val();
            });
          }
          if (form.data('form' === 'login')) {
            login = true;
            username = aD.username != null ? aD.username : params.user.username;
            password = aD.password != null ? aD.password : params.user.password;
          } else {
            login = false;
          }
          return $.ajax({
            type: type,
            url: url,
            data: params,
            beforeSend: function(xhr) {
              return xhr.setRequestHeader("Authorization", "Basic " + btoa(username + ":" + password));
            }
          }).done(function(data) {
            if (login) {
              aD.username = username;
              aD.password = password;
              $.when(aM.check_username(username)).done(function() {
                aM.render_login_info();
                return aM.load_topics_list();
              });
            }
            return aM.render_done_state(model, type, self, data);
          }).fail(function(xhr, s) {
            return alert(xhr.status + ': ' + xhr.responseText);
          });
        }
      }
    };
    return {
      init: function() {
        $('nav').on('change', '#navbar[data-form="login"] input[type="text"]', aM.data_check_username);
        $('nav').on('click', '[data-logout]', aM.logout);
        $('body').on('click', '[data-submit]', aM.common_submit);
        $('#work-space').on('change', '[data-form] input, [data-form] textarea', aM.enable_update);
        aM.render_login_info();
        return aM.load_topics_list();
      },
      test_stub: function() {
        return $.getJSON(aD.server + "/users.json").done(function(data) {
          return $('#work-space').loadTemplate($('#users-table'), {}, {
            afterInsert: function() {
              return $('#users-list').loadTemplate($('#user'), data);
            }
          });
        });
      }
    };
  };

}).call(this);
