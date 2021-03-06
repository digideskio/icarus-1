Template._timeline.rendered = ->
	Meteor.setTimeout ->
		e = document.createEvent('UIEvents')
		e.initUIEvent('click', true, true)
		d3.select('.monthly-transaction').node().dispatchEvent(e)
	, 250

	# Meteor.setTimeout(function(){
  #   var e = document.createEvent('UIEvents');
  #   e.initUIEvent('click', true, true);
  #   d3.select(".pie-slice").node().dispatchEvent(e);
  # }, 1000)


	Session.setDefault 'data', []

	height = d3.select('#_timeline').property('clientHeight') - 20
	width = d3.select('#_timeline').property('clientWidth')

	box = {s: 5}

	barShape = {width: 15}

	xAxisTransform = 20
	yAxisTransform = 60

	data = Portfolios.find({'owner._id': Meteor.user()._id}).fetch()

	debtLines = _.where(data, {type: 'debt'})
	equityLines = _.where(data, {type: 'equity'})

	dateAsc = (a, b) ->
		dateA = new Date a.date
		dateB = new Date b.date
		return dateA - dateB

	dateFormat = d3.time.format("%b")

	allDebt = _.flatten debtLines
	sortDebt = Array.prototype.slice.call allDebt
	sortDebt = sortDebt.sort dateAsc

	monthlyDebt = d3.nest()
				.key (d) -> dateFormat new Date d.date
				.rollup (d) -> d
				.entries sortDebt

	monthlyDebtDetails = _.pluck monthlyDebt, 'values'

	allEquity = _.flatten equityLines
	sortEquity = Array.prototype.slice.call allEquity
	sortEquity = sortEquity.sort dateAsc

	monthlyEquity = d3.nest()
				.key (d) -> dateFormat new Date d.date
				.rollup (d) -> d
				.entries sortEquity

	monthlyEquityDetails = _.pluck monthlyEquity, 'values'

	allData = sortDebt.concat(sortEquity)

	monthlyAll = d3.nest()
				.key (d) -> dateFormat new Date d.date
				.rollup (d) -> d
				.entries allData

	shortDate = d3.time.format("%b %Y")

	debtIndex = 0
	debtTotals = d3.nest()
				.key (d) -> dateFormat new Date d.date
				.rollup (d) ->
					date = shortDate new Date d[0].date
					sum = d3.sum(d, (g) -> +g.amount)
					object = {
						amount: sum
						type: 'debt'
						date: date
						long_date: new Date date
						details: monthlyDebtDetails[debtIndex]
					}
					debtIndex++
					return object
				.entries allDebt

	equityIndex = 0
	equityTotals = d3.nest()
				.key (d) -> dateFormat new Date d.date
				.rollup (d) ->
					date = shortDate new Date d[0].date
					sum = d3.sum(d, (g) -> +g.amount)
					object = {
						amount: sum
						type: 'equity'
						date: date
						long_date: new Date date
						details: monthlyEquityDetails[equityIndex]
					}
					equityIndex++
					return object
				.entries allEquity

	monthlyBalance = _.pluck(debtTotals, 'values').concat(_.pluck(equityTotals, 'values'))

	monthlyTotals = d3.nest()
				.key (d) -> dateFormat new Date d.date
				.rollup (d) -> d
				.entries monthlyBalance

	allMonthlyTotals = d3.nest()
				.key (d) -> dateFormat new Date d.date
				.rollup (d) ->
					d3.sum(d, (g) -> +g.amount)
				.entries allData

	yDomain = d3.extent(allMonthlyTotals, (d) -> d.values)
	xDomain = d3.extent(allData, (d) -> new Date(d.date))

	y0 = Math.abs yDomain[1]
	y1 = Math.abs yDomain[0]
	yMax = d3.max([y0, y1])

	xScale = d3.scale.ordinal()
		.domain _.pluck monthlyTotals, 'key'
		.rangeRoundBands [yAxisTransform, width - yAxisTransform], 0.1

	yScale = d3.scale.linear()
		.domain [yDomain[1], 0]
		.rangeRound [xAxisTransform, height - xAxisTransform]

	colorScale = d3.scale.category10()
					.domain ['equity', 'debt']

	svg = d3.select '#_timeline'
		.append('svg')
		.attr 'class', 'equity-debt'
		.attr
			height: height,
			width: width

	axis = svg.append 'g'
			.attr 'class', 'axis'

	# xAxis = d3.svg.axis()
	# 	.scale xScale
	# 	.ticks(12)
	# 	.tickFormat (d) -> dateFormat(d)
	# 	.orient 'bottom'

	xAxis = d3.svg.axis()
		.scale xScale
		.orient "bottom"

	yAxis = d3.svg.axis()
		.scale yScale
		.ticks(8)
		.tickFormat (d) -> (d3.formatPrefix(d).scale(d) + d3.formatPrefix(d).symbol)
		.orient 'left'

	axis.append 'g'
		.attr 'class', 'x-axis'
		.attr 'transform', 'translate(0,' + (height-xAxisTransform) + ')'
		.attr
			stroke: '#D1122B'
		.call xAxis

	axis.append 'g'
		.attr 'class', 'y-axis'
		.attr 'transform', 'translate(' + yAxisTransform + ',0)'
		.attr
			stroke: '#D1122B'
		.call yAxis

	month = svg.selectAll('.monthly-total')
		.data monthlyTotals
		.enter()
			.append 'g'
			.attr 'class', 'monthly-total'
			.attr 'transform', (d) ->
				"translate("+xScale(d.key)+", 0)"

	transaction = month.selectAll('.monthly-total')
		.data (d) -> d.values
		.enter()
		.append 'rect'
		.attr 'class', 'monthly-transaction'
		.attr 'selected', false
		.attr 'height', (d) -> yScale(0) - yScale(d.amount)
		.attr 'y', (d, i) ->
			if i isnt 0
				parent = d3.select(this).node().parentNode
				sibling = parent.childNodes
				current = d3.select(sibling[i-1]).attr('y')
				return (current - (yScale(0) - yScale(d.amount)))
			else
				yScale(0) - (yScale(0)- yScale(d.amount)) #y0
		.attr 'width', xScale.rangeBand()
		.attr 'fill', (d) -> colorScale d.type
		.on 'click', setSelected
		# .on 'click', (d) ->
		# 	d3.select(@).attr 'class', 'selected'
		# 	Session.set 'data', d
		.on 'mouseover', (d) ->
			d3.select(@).attr 'opacity', 0.8
		.on 'mouseout', (d) ->
			d3.select(@).attr 'opacity', 1

Template._timeline.helpers
	dataDE: ->
		Session.get 'data'

	propName: (id) ->
		Properties.findOne(id).street


# setSelected is a function that will be able to retrieve the details of the monthly transactions + set current bar opaque -- will reset opacity of previous selection

setSelected = ->
	d3.select('.equity-debt').selectAll('rect').each ->
		d3.select(@).classed 'debt-equity-selected', false
	d3.select(@).classed 'debt-equity-selected', true
	data = d3.select(@).datum()
	console.log data
	Session.set 'data', data
