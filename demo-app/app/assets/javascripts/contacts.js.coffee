# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
$ ->
  attachDraggables()
  attachDropTargets()

  # index
  $('#lead_type_dialog').dialog(
    autoOpen: false,
    height: 75,
    width: 50,
    modal: true)

  $('.contact_lead_type').live('click', (e) ->
    e.preventDefault()
    $('#lead_types img').attr('data-contact_id', this.dataset.contact_id)
    openLeadTypeSelection()
  )

  $('.lead_type_selection').live('click', (e) ->
    e.preventDefault()
    updateLeadType(this.dataset.contact_id, this.dataset.lead_type)
  )

  # form
  handleClicks '#view_contact_linkedin_profile', openInIframe

attachDraggables = () ->
  draggables = $('#lead_types img')
  [].forEach.call(draggables, (draggable) ->
    draggable.addEventListener('dragstart' , handleDragStart , false)
    draggable.addEventListener('dragend'   , handleDragEnd   , false)
  )

attachDropTargets = () ->
  drop_targets = $('#drop_target')
  [].forEach.call(drop_targets, (target) ->
    target.addEventListener('dragenter' , handleDragEnter , false)
    target.addEventListener('dragover'  , handleDragOver  , false)
    target.addEventListener('dragleave' , handleDragLeave , false)
    target.addEventListener('drop'      , handleDrop      , false)
  )

handleDragStart = (e) ->
  e.dataTransfer.effectAllowed = 'move'
  e.dataTransfer.setData('text/html', @innerHTML)

handleDragOver = (e) ->
  e.preventDefault() if e.preventDefault() # Necessary. Allows us to drop.
  e.dataTransfer.dropEffect = 'move'

handleDragEnter = (e) ->
  $(this).addClass 'over'

handleDragLeave = (e) ->
  $(this).removeClass 'over'

handleDrop = (e) ->
  e.stopPropagation() if e.stopPropagation() # stops the browser from redirecting.

  lead_types = new Array()
  lead_types['hot-icon.png'] = 'HOT'
  lead_types['neutral-icon.png'] = 'NEUTRAL'
  lead_types['cold-icon.png'] = 'COLD'

  @innerHTML = e.dataTransfer.getData 'text/html'
  transferredIcon = getIcon(e.dataTransfer.getData('text/html'))
  $('#contact_lead_type').val(lead_types[transferredIcon])

handleDragEnd = (e) ->
  drop_targets = $('#drop_target')
  [].forEach.call(drop_targets, (target) ->
    $(target).removeClass 'over'
  )

getIcon = (data) ->
  /(hot-icon\.png|neutral-icon\.png|cold-icon\.png)/i.exec(data)[0]

openInIframe = () ->
  $('#linkedin_frame').attr('src', '/static/Jim_Holmes_LinkedIn.html')

openLeadTypeSelection = () ->
  $('#lead_type_dialog').dialog 'open'

closeLeadTypeSelection = () ->
  $('#lead_type_dialog').dialog 'close'

updateLeadType = (id, lead_type) ->
  $.ajax(
    type: 'POST'
    url: "/contacts/update_lead_type",
    data: "id=#{id}&lead_type=#{lead_type}",
    success: (data) -> updateLeadTypeSuccess(data),
  )

updateLeadTypeSuccess = (data) ->
  closeLeadTypeSelection()
  # refresh list

