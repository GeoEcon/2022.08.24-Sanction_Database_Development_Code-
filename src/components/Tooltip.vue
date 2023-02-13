<template>
  <div 
    :style="{ 
      'display' : display ? 'inherit' : 'none',
      'transform' : `translate(${transX}px,${transY}px)`,
      'border' : `2px solid ${color}`
    }" 
    class="py-2 rounded-lg shadow-md bg-white absolute z-50 top-0 left-0">

    <div class="text-center text-lg font-bold pb-2" :style="{ 'border-bottom' : `0px solid ${color}` }">Sanctioned <span :style="{ 'color': this.color }" class="uppercase">{{ title }}</span> By Countries</div> 
    <div :id="`bars-svg-${title}`">
    </div>
  </div>
</template>

<script>
import * as d3 from "d3";

export default {
  props: ["title", "display", "triggerTransition", "transX", "transY", "widthBars", "heightBars", "dataBars", "updateBars", "color"],
  methods: {
    drawBars() {

      // cleaning 
      d3.select(`#bars-svg-${this.title}`)
        .html('');

      // restructuring dataBars to be barChart friendly
      let data = [];
      for (let [key, value] of Object.entries(this.dataBars)) {
        data.push({
          "country": key, "value": value
        })
      }

      const width = this.widthBars;
      const height = this.heightBars;
      const margin = 20;

      // Construct scales and axes.
      const xDomain = [0, d3.max(data, d => d.value)]; // to fix // [0, d3.max(X)]
      const yDomain = d3.groupSort(data, ([d]) => -d.value, d => d.country); // d3.groupSort(alphabet, ([d]) => -d.frequency, d => d.letter)
      const yPadding = 0.4;
      // const xFormat = "";
      const xLabel = "Sanctions →";
      const xScale = d3.scaleLinear(xDomain, [margin, width - margin]);
      const yScale = d3.scaleBand(yDomain, [margin, height - margin]).padding(yPadding);
      
      // const xAxis = d3.axisTop(xScale).ticks(width / 80, xFormat);
      const yAxis = d3.axisLeft(yScale).tickSize(0);

      const svg = d3.select(`#bars-svg-${this.title}`)
        .append('svg')
        .attr("style", "border:2px solid black;")
        .attr("width", width)
        .attr("height", height)
        .attr("viewBox", [0, 0, width, height])
        .attr("style", "max-width: 100%; height: auto; height: intrinsic; overflow:visible;");

      svg.append("g")
        .attr("transform", `translate(0,${margin})`)
        // .call(xAxis)
        // .call(g => g.select(".domain").remove())
        .call(g => g.selectAll(".tick line").clone()
            .attr("y2", height - margin*2)
            .attr("stroke-opacity", 0.1))
        .call(g => g.append("text")
            .attr("x", width - margin)
            .attr("y", 4)
            .attr("fill", "currentColor")
            .attr("text-anchor", "end")
            .text(xLabel));


      svg.append("g")
        .attr("fill", this.color)
        .selectAll("rect")
        .data(data)
        .join("rect")
        .attr("rx", "2px")
        .attr("id", `bar-${this.title}`)
        .attr("ry", "2px")
        .attr("stroke-linecap", "round")
        .attr("x", xScale(0))
        .attr("y", d => yScale(d.country))
        .attr("width", 0)
        .attr("height", yScale.bandwidth())
        .transition()
          .delay(0)
          .duration(1800)
          .attr("width", d => xScale(d.value) - xScale(0))
        
        ;

      svg.append("g")
        .attr("transform", `translate(${margin},0)`)
        .call(yAxis)
        .call(g => g.selectAll(".tick text")
            .attr("text-anchor", "start")
            .attr("font-weight", "bold")
            .attr("font-size", 18)
            .attr("transform", `translate(2,-30)`))
        .call(g => g.select(".domain").remove());

      // value on bar
      svg.append("g")
        .attr("fill", () => this.color != "#235a9d " ? "#ffffff" : "#ffffff")
        .attr("text-anchor", "end")
        .attr("font-family", "sans-serif")
        .attr("font-weight", "bold")
        .attr("font-size", 15)
      .selectAll("text")
      .data(data)
      .join("text")
        .attr("x", (d, i) => data[i] !== undefined ? xScale(data[i].value) : '')
        .attr("y", (d, i) => data[i] !== undefined ? yScale(data[i].country) + yScale.bandwidth() / 2 : '')
        .attr("dy", "0.35em")
        .attr("dx", -4)
        .attr("opacity", d => d.value == 0 ? 0 : 1)
        .text(d => d.value)
        /*
        .call(text => text.filter(i => data[i] !== undefined ? xScale(data[i].value) - xScale(0) < 20 : '') // short bars
            .attr("opacity", d => d.value == 0 ? 0 : 1)
            .attr("dx", 10)
            .attr("text-anchor", "start")
            )
            */
            ;

      return svg
    }
  },
  watch: {
    /*
    updateBars(o,n) {
      console.log(o, n);
      this.drawBars();
    },
    */
    triggerTransition(o, n) {
      console.log(o, n);
      if (!n) {
        this.drawBars();
      }
      
    }
  },

}
</script>

<style lang="scss" scoped>

</style>