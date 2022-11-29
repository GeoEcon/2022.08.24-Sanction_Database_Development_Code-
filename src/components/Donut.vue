<template>
  <div class="shadow-md w-full h-full">
    <div class="p-4 flex ">
      <div class="relative">
        <svg class="mx-auto" :width="width" :height="height" :id="id">
        </svg>
        <div class="font-bold text-lg container-fig">
          {{ formattedPercentage }}
        </div>
      </div>
      <div>
        <div class="font-bold px-2 text-2xl text-left">{{ sanctionsCountByType[label] }}</div>
        <div :style="{ color: this.color }" class="text-left font-bold p-2 text-lg">{{ labelPlural }}</div>
      </div>
    </div>
  </div>
</template>

<script>
import * as d3 from "d3";

export default {
  name: 'Donut',
  props: ["color", "label", "labelPlural", "id", "count", "totalSanctions", "sanctionsCountByType"],
  computed: {
    formattedPercentage() {
      console.log(this.totalSanctions)
      let val = (this.sanctionsCountByType[this.label]/this.totalSanctions) * 100;
      if (this.totalSanctions == 0) {
        val = ""
      } else {
        val = val.toFixed(1) + "%";
      }
      console.log(typeof val)
      
      return val
    }
  },
  methods: {
    donutDraw() {
      const data = [
        { 
          'val': this.sanctionsCountByType[this.label], 
          'opacity': 1,
        }, 
        {
          'val': this.totalSanctions - this.sanctionsCountByType[this.label],
          'opacity': 0.2,
        }
      ] 

      const svg = d3.select(`#${this.id}`);

      const width = this.width;
      const height = this.height;

      // const arcs = d3.pie().padAngle(padAngle).sort(null).value(i => V[i])(I);
      // const arc = d3.arc().innerRadius(innerRadius).outerRadius(outerRadius);

      const pie = d3.pie()
        .value((d) => d.val)
      
      const arc = d3.arc()
        .innerRadius(width/3)
        .outerRadius(width/2)
      
      svg.attr("width", width)
      .attr("height", height)
      .attr("viewBox", [-width / 2, -height / 2, width, height])
      .attr("style", "max-width: 100%; height: auto; height: intrinsic;");

      svg.append("g")
        //.attr("stroke", stroke)
        //.attr("stroke-width", strokeWidth)
        //.attr("stroke-linejoin", strokeLinejoin)
      .selectAll("path")
      .data(pie(data))
      .join("path")
        .attr("fill", this.color)
        .attr("opacity", (d,i) => data[i].opacity)
        .attr("d", arc) 
    }
  },
  mounted() {
    this.donutDraw();
  },
  watch: {
    count() {
      this.donutDraw();
    }
  },
  data() {
    const width = 125;
    const height = 125;
    return {
      width, height
    }
  }
}
</script>

<style scoped>
.container-fig {
  transform: translate(-50%, -50%);
  position:absolute;
  top:50%;
  left:50%;
}
</style>