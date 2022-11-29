<template>
  <div>
    <div class="shadow-md p-4 flex w-full h-full items-center justify-around">
      <div>
        <img src="/avatar.png">
      </div>
      <div>
        <div class="font-bold px-2 text-2xl text-left">{{ totalSanctions }}</div>
        <div  class="text-left font-bold px-2 text-lg">Total Sanctions</div>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    props: ["totalSanctions"],
    
  }
</script>

<style  scoped>
img {
  border:none;
  min-width: 50px;
}
</style>