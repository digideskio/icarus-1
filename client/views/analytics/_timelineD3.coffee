# Template._timeline.rendered = ->


# 	createTimeline = -> 

# 		owner = 'sam'

# 		height = d3.select('#_timeline').property('clientHeight') - 20
# 		width = d3.select('#_timeline').property('clientWidth')

# 		box = {s: 5}

# 		xAxisTransform = 20
# 		yAxisTransform = 60

# 		data = Portfolios.find({owner: owner}).fetch()

# 		debtLines = _.pluck(data, 'd')
# 		equityLines = _.pluck(data, 'e')

# 		allDebt = _.flatten debtLines
# 		allEquity = _.flatten equityLines

# 		allData = allDebt.concat(allEquity).sort (a, b) -> (new Date(b.date) - new Date(a.date))


# 		yDomain = d3.extent(allData, (d) -> d.amount)
# 		xDomain = d3.extent(allData, (d) -> new Date(d.date))

# 		svg = d3.select '#_timeline'
# 				.append('svg')
# 				.attr 'class', 'equity-debt'
# 				.attr 
# 					height: height,
# 					width: width

# 		legend = {x: 25, y: 30, boxWidth: 120, boxHeight: data.length * 27.5, color: 5}

# 		equityOnly = svg.append('rect')
# 			.attr 'width', 20
# 			.attr 'height', '50'
# 			.attr 'x', 495
# 			.attr 'y', 0
# 			.attr 'fill', 'black'

# 		xScale = d3.time.scale()
# 		.domain xDomain
# 		.range [yAxisTransform, width - yAxisTransform]
		
# 		yScale = d3.scale.linear()
# 		.domain [yDomain[1], yDomain[0]]
# 		.range [xAxisTransform, height - xAxisTransform]

# 		colorScale = d3.scale.category10()

# 		axis = svg.append 'g'
# 				.attr 'class', 'axis'

# 		xAxis = d3.svg.axis()
# 				.scale xScale
# 				.ticks 6
# 				.orient 'bottom'

# 		yAxis = d3.svg.axis()
# 				.scale yScale
# 				.ticks 8
# 				.tickFormat (d) -> (d3.formatPrefix(d).scale(d) + d3.formatPrefix(d).symbol)
# 				.orient 'left'
				
# 		mousemove = ->
# 			bisect = d3.bisector((d) -> new Date d.date).left
# 			position = d3.mouse(this)
# 			x = xScale.invert(position[0])
# 			date = d3.time.format('%b %d, %Y')
# 			money = d3.format(',.2f')
# 			range = d3.extent allData, (d) -> new Date(d.date)
# 			mid = new Date(range[1] - ((range[1] - range[0])/2))

# 			d3.select '#_timeline #vertical-line'
# 				.attr 'x1', position[0]
# 				.attr 'x2', position[0]

# 			if x > mid
# 				d3.selectAll '#_timeline .legend'
# 					.attr 'x', (position[0] - legend.boxWidth)
# 					.attr 'y', (position[1])
# 			else 
# 				d3.selectAll '#_timeline .legend'
# 					.attr 'x', (position[0])
# 					.attr 'y', (position[1])

# 			d3.selectAll('#_timeline #tracer').each (d) -> 
# 				set = d3.select(this).datum()
# 				i = bisect(set, x)
# 				if i >= set.length then i = set.length-1 
# 				min = d3.min(set, (d) -> new Date d.date )
# 				max = d3.max(set, (d) -> new Date d.date )


# 				if min < x < max
# 					d3.select(this)
# 						.style('display', null)
# 						.attr 'x', (position[0] - box.s)
# 						.attr 'y', (yScale(set[i].amount) - box.s)
# 				else
# 					d3.select(this).style('display', 'none')

# 			d3.selectAll('#_timeline #key-values').each (d, index) ->
# 				set = d3.select(this).datum()
# 				i = bisect(set, x)
# 				if i >= set.length then i = set.length-1
# 				min = d3.min(set, (d) -> new Date d.date)
# 				max = d3.max(set, (d) -> new Date d.date)

# 				d3.select(this).attr 'y', (position[1] + ((index * 20) + box.s + legend.y))

# 				if x < mid
# 					d3.select(this)
# 						.attr 'x', (position[0] + (legend.boxWidth - (box.s*2)))
# 				else 
# 					d3.select(this)
# 						.attr 'x', (position[0] - (box.s*2))
				
# 				if min < x < max
# 					d3.select(this)
# 						.text('$ ' + money(set[i].amount))
# 				else 
# 					d3.select(this)
# 						.text('No History')

# 			d3.selectAll('#_timeline .legend#date').each (d, index) ->
# 				d3.select(this)
# 					.attr 'y', (position[1] + 12.5)
# 					.text date(x)

# 				if x < mid 
# 					d3.select(this).attr 'x', (position[0] + (legend.boxWidth/2))
# 				else
# 					d3.select(this).attr 'x', (position[0] - (legend.boxWidth/2))

# 		axis.append 'g'
# 			.attr 'class', 'x-axis'
# 			.attr 'transform', 'translate(0,' + (height-xAxisTransform) + ')'
# 			.attr 
# 				stroke: '#D1122B'
# 			.call xAxis

# 		axis.append 'g'
# 			.attr 'class', 'y-axis'
# 			.attr 'transform', 'translate(' + yAxisTransform + ',0)'
# 			.attr
# 				stroke: '#D1122B'
# 			.call yAxis

# 		grid = svg.append 'g'
# 			.attr 'class', 'grid'

# 		grid.append 'g'
# 			.attr 'class', 'xGrid'
# 			.attr 'transform', 'translate(0,' + (height-xAxisTransform) + ')'
# 			.call xAxis.tickSize(-height, 0, 0).tickFormat("")

# 		grid.append 'g'
# 			.attr 'class', 'yGrid'
# 			.attr 'transform', 'translate(' + yAxisTransform + ',0)'
# 			.call yAxis.tickSize(-width + (2 * yAxisTransform), 0, 0).tickFormat("")

# 		rect = svg.append 'g'
# 			.attr 'class', 'background'
# 			.attr 'fill', 'white'
# 			.attr 'opacity', 0.8

# 		rect.append 'rect'
# 			.attr 'x', yAxisTransform
# 			.attr 'width', width - (2 * yAxisTransform)
# 			.attr 'height', height - 20
# 		    .on "mousemove", mousemove
# 		    .on "mouseover", -> 
# 		    	legendGroup.style 'display', null
# 		    	d3.selectAll('#_timeline #tracer').style 'display', null
# 		    .on "mouseout", -> 
# 		    	legendGroup.style 'display', 'none'
# 		    	d3.selectAll('#_timeline #tracer').style 'display', 'none'

# 		vertical = svg.append('line')
# 			.attr 'x1', yAxisTransform
# 			.attr 'y1', 0
# 			.attr 'x2', yAxisTransform
# 			.attr 'y2', height - 20
# 			.attr 'stroke', 'red'
# 			.attr 'id', 'vertical-line'

# 		line = d3.svg.line()
# 			.interpolate('linear')
# 			.x (d) -> xScale new Date(d.date)
# 			.y (d) -> yScale d.amount

# 		debtGroup = svg.append 'g'
# 			.attr 'class', 'debt'

# 		debtGroup = debtGroup.selectAll('.debt')
# 			.data(debtLines)
# 			.enter()
# 			.append('g')
# 			.attr('class', 'debt')
		
# 		debtGroup.append('path')
# 			.attr 'class', 'line'
# 			.attr 'd', (d) -> line(d)
# 			.attr 'stroke', (d, i) -> colorScale(i%5)
# 			.attr 'stroke-width', '1'
# 			.attr 'fill', 'none'

# 		debtGroup.append 'rect'
# 			.attr 'class', 'legend'
# 			.attr 'id', 'tracer'
# 			.attr 'width', box.s * 2
# 			.attr 'height', box.s * 2
# 			.attr 'fill', (d, i) -> colorScale(i%5)
# 			.style 'display', 'none'

# 		equityGroup = svg.append 'g'
# 			.attr 'class', 'equity'

# 		equityGroup = equityGroup.selectAll('#_timeline .equity')
# 			.data(equityLines)
# 			.enter()
# 			.append('g')
# 			.attr('class', 'equity')
		
# 		equityGroup.append('path')
# 			.attr 'class', 'line'
# 			.attr 'd', (d) -> line(d)
# 			.attr 'stroke', (d, i) -> colorScale(i%5)
# 			.attr 'stroke-width', '1'
# 			.attr 'fill', 'none'

# 		equityGroup.append 'rect'
# 			.attr 'class', 'legend-group'
# 			.attr 'id', 'tracer'
# 			.attr 'width', box.s * 2
# 			.attr 'height', box.s * 2
# 			.attr 'fill', (d, i) -> colorScale(i%5)
# 			.style 'display', 'none'

# 		legendGroup = debtGroup.append 'g'
# 			.attr 'class', 'legend-group'
# 			.style 'display', 'none'

# 		legendGroup.append 'rect'
# 			.attr 'class', 'legend'
# 			.attr 'id', 'content-box'
# 			.attr 'height', legend.boxHeight
# 			.attr 'width', legend.boxWidth
# 			.attr 'stroke', '#D1122B'
# 			.attr 'stroke-width', 1
# 			.attr 'fill', 'none'

# 		legendGroup.append 'rect'
# 			.attr 'class', 'legend'
# 			.attr 'id', 'date-box'
# 			.attr 'height', 20
# 			.attr 'width', legend.boxWidth
# 			.attr 'fill', '#D1122B'

# 		legendGroup.append 'rect'
# 			.attr 'class', 'legend'
# 			.attr 'id', 'key-colors'
# 			.attr 'height', 5
# 			.attr 'width', 5
# 			.attr 'fill', (d, i) -> colorScale(i%5)
# 			.attr 'transform', (d, i) -> 'translate(' + (box.s*2) + ',' + ((i * 20) + legend.y) + ')'

# 		legendGroup.append 'text'
# 			.attr 'class', 'legend'
# 			.attr 'id', 'key-values'
# 			.attr 'fill', (d, i) -> colorScale(i%5)
# 			.attr 'text-anchor', 'end'
# 			.style 'font-size', '12px'

# 		legendGroup.append 'text'
# 			.attr 'class', 'legend'
# 			.attr 'id', 'date'
# 			.attr 'fill', 'white'
# 			.attr 'text-anchor', 'middle'
# 			.style 'font-size', '12px'

# 	createTimeline()