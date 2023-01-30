const shardResource = async (resource, SHARD_AMOUNT) => {
   const RESULT_LENGTH = resource.length;
   let index_now = 0;
   let part_1 = [];
   let part_2 = [];
   let part_3 = [];
   let maxFreqPart_1 = 0;
   let maxFreqPart_2 = 0;
   let maxFreqPart_3 = 0;
   const shardFrequency = RESULT_LENGTH / SHARD_AMOUNT;

   if (RESULT_LENGTH % SHARD_AMOUNT != 0) {
      maxFreqPart_1 = shardFrequency;
      maxFreqPart_2 = maxFreqPart_1 + shardFrequency;
      maxFreqPart_3 = maxFreqPart_2 + (RESULT_LENGTH - maxFreqPart_2);
   } else {
      maxFreqPart_1 = shardFrequency;
      maxFreqPart_2 = shardFrequency * 2
      maxFreqPart_3 = shardFrequency * 3
   }

   for (let data in resource) {
      if (data <= maxFreqPart_1) {
         part_1.push(resource[data])
      }

      if (data > maxFreqPart_1 && data <= maxFreqPart_2) {
         part_2.push(resource[data])
      }

      if (data > maxFreqPart_2 && data <= maxFreqPart_3) {
         part_3.push(resource[data])
      }
   }

   return {
      part_1,
      part_2,
      part_3
   }
}

module.exports = shardResource;
